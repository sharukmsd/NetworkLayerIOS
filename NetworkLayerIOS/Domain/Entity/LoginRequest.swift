//
//  LoginRequest.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import Foundation

protocol EndpointRequest: Codable {}

struct LoginRequest: EndpointRequest {
    let email: String
    let password: String
}
