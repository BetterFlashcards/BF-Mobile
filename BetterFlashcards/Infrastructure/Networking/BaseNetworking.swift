//
//  BaseNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

class BaseNetworking {
    let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func convertResult<T, E>(result: Result<Response<T>, E>) throws -> T {
        switch result {
        case .success(let response):
            return response.data
        case .failure(let error):
            throw error
        }
    }
}

class BaseAuthenticatedNetworking: BaseNetworking {
    let tokenProvider: any TokenProviderProtocol
    
    init(client: APIClient, tokenProvider: any TokenProviderProtocol) {
        self.tokenProvider = tokenProvider
        super.init(client: client)
    }
    
    func headers() async throws -> BearerHeaders<[String: String]> {
        let token = try tokenProvider.token()
        return BearerHeaders(token: token)
    }
}
