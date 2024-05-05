//
//  BaseNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

typealias Client = any AsyncClient

class BaseNetworking {
    let client: Client
    
    init(client: Client) {
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
    let authStore: any AuthStoreProtocol
    
    init(client: Client, authStore: any AuthStoreProtocol) {
        self.authStore = authStore
        super.init(client: client)
    }
    
    func headers() async throws -> BearerHeaders<[String: String]> {
        let token = try authStore.token()
        return BearerHeaders(token: token)
    }
}
