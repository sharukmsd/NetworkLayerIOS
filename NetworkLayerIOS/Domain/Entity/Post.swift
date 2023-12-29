//
//  Post.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import Foundation

struct PostRequest: EndpointRequest {
    let title: String
    let body: String
    let userId: Int
}

struct CreatePostResponse: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
