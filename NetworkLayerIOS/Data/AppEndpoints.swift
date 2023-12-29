//
//  AppEndpoints.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import Foundation

enum AppEndpoints {
    case login(EndpointRequest)
    case register(EndpointRequest)
    case createPost(EndpointRequest)
    case user
}

extension AppEndpoints: Endpoint {    
    
    var path: String {
        switch self {
        case .login:
            return "/rest-auth/login/"
        case .register:
            return "/register"
        case .createPost:
            return "/posts"
        case .user:
            return "/user"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .login, .register, .createPost, .user:
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
            
        case .login, .register, .createPost:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        default:
            return ["Authorization": "Token \(UserDefaults.standard.string(forKey: "Constants.loginKey.rawValue") ?? "")",
                    "Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var query: [String : Any]? {
                
        switch self {

        default:
            return nil
        }
    }
    
    var body: Codable? {
        switch self {
            
        case .login(let request), .register(let request), .createPost(let request):
            return request
            
        default:
            return nil
        }
    }
    
}
