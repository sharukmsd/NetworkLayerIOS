//
//  AppService.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import Foundation

struct AppService: HTTPClient {
    func createPost(request: PostRequest) async -> Result<CreatePostResponse, NetworkError> {
        return await sendRequest(endpoint: AppEndpoints.createPost(request), responseModel: CreatePostResponse.self)
    }
}
