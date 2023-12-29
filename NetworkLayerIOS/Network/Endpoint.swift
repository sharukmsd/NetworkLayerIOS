//
//  Enpoint.swift
//  Holla data
//
//  Created by Shahrukh on 30/10/2023.
//

import Foundation

public protocol Endpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var query: [String: Any]? { get }
    var body: Codable? { get }
}

extension Endpoint {
    var baseUrl: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
}

public enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
