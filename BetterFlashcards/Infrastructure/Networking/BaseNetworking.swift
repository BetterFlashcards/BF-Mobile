//
//  BaseNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

typealias Client = any AsyncClient
typealias PaginatedAuthRequest<T> = AdvancedRequest<Nothing, BearerHeaders<[String: String]>, PaginationQueryDTO?, ListDTO<T>> where T: Codable

protocol BaseNetworkingProtocol { }

extension BaseNetworkingProtocol {
    func convertResult<T, E>(result: Result<Response<T>, E>) throws -> T {
        switch result {
        case .success(let response):
            return response.data
        case .failure(let error):
            throw error
        }
    }
}

class BaseAuthenticatedNetworking: BaseNetworkingProtocol {
    let client: Client
    let authStore: any AuthStoreProtocol
    let authProvider: any AuthProviderProtocol
    
    init(client: Client, authStore: any AuthStoreProtocol, authProvider: any AuthProviderProtocol) {
        self.authStore = authStore
        self.authProvider = authProvider
        self.client = client
    }
    
    func headers() async throws -> BearerHeaders<[String: String]> {
        let token = try authStore.token()
        let verified = try? await self.authProvider.verify(token: token)
        if let verified, verified {
            return BearerHeaders(token: token)
        } else {
            let refresh = try authStore.refresh()
            do {
                let refreshedToken = try await authProvider.refresh(token: refresh)
                return BearerHeaders(token: refreshedToken)
            } catch {
                authStore.clearUserInfo()
                throw AuthError.expired
            }
        }
    }
}
