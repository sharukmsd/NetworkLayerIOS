//
//  HTTPClient.swift
//  Katch
//
//  Created by Shahrukh on 30/10/2023.
//

import Foundation
import SwiftUI

public protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError>
    func upload<T: Decodable>(file: Data, endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError>
}

extension HTTPClient {
    
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError> {
        
        guard var urlComponents = URLComponents(url: endpoint.baseUrl.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            return .failure(.invalidEndpoint)
        }
        
        urlComponents.queryItems = endpoint.query?.map({ (key: String, value: Any) in
            return URLQueryItem(name: key, value: value as? String)
        })
        
        guard let url = urlComponents.url else {
            return .failure(.invalidEndpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        do {
            
            #if DEBUG
            print("➡️ URL: \(request.url!)")
            print("➡️ body: \(String(decoding: request.httpBody ?? Data(), as: UTF8.self))")
            print("HEADERS")
            request.allHTTPHeaderFields?.forEach { print("⎯> \($0.key) : \($0.value)") }
            #endif
            
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
            #if DEBUG
            print("➡️ data: \(String(decoding: data, as: UTF8.self))")
            print("➡️ response: \(response)")
            #endif

            guard let response = response as? HTTPURLResponse, 200..<401 ~= response.statusCode else {
                return .failure(NetworkErrorHandler.mapError((response as? HTTPURLResponse)?.statusCode ?? 0))
            }

            #if DEBUG
            print("➡️ status code: \(response.statusCode)")
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print("✅ JSON String: \(String(decoding: jsonData, as: UTF8.self))")
                
                do{
                    let output = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
                    print("🌴 from data object: \(String(describing: output?["message"]))")
                }
                catch {
                    print (error)
                }
            } else {
                print("json data malformed")
            }
            #endif
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return .success(decodedResponse)
            } catch let error as NSError {
                dump(error)
                return .failure(.decode)
            }

        } catch (let error) {
            print(error.localizedDescription)
            return .failure(.unknown)
        }
        
    }
        
}

extension HTTPClient {

    func upload<T: Decodable>(file: Data, endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError> {

        guard var urlComponents = URLComponents(url: endpoint.baseUrl.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            return .failure(.invalidEndpoint)
        }

        urlComponents.queryItems = endpoint.query?.map({ (key: String, value: Any) in
            return URLQueryItem(name: key, value: value as? String)
        })

        guard let url = urlComponents.url else {
            return .failure(.invalidEndpoint)
        }

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Abcdefghijklmopqrstuvwxyz", forHTTPHeaderField: "API_KEY")

        var requestData = Data()

        // Add the image data to the raw http request data
        requestData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("Content-Disposition: form-data; name=\"\("image")\"; filename=\"\("image")\"\r\n".data(using: .utf8)!)
        requestData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        requestData.append(file)

        requestData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        //let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        do {
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: requestData)

            guard let response = response as? HTTPURLResponse, 200..<401 ~= response.statusCode else {
                return .failure(NetworkErrorHandler.mapError((response as? HTTPURLResponse)?.statusCode ?? 0))
            }

            #if DEBUG
            print("➡️ status code: \(response.statusCode)")

            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print("✅ JSON String: \(String(decoding: jsonData, as: UTF8.self))")

                do{
                    let output = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
                    print("🌴 from data object: \(String(describing: output?["message"]))")
                }
                catch {
                    print (error)
                }
            } else {
                print("json data malformed")
            }
            #endif

            do {
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return .success(decodedResponse)
            } catch let error as NSError {
                dump(error)
                return .failure(.decode)
            }

        } catch {
            print(error)
            return .failure(.unknown)
        }
    }
}
