//
//  RegisterRequest.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import Foundation

struct RegisterRequest: EndpointRequest {
    let name: String
    let email: String
    let password: String
    let address: String
}
