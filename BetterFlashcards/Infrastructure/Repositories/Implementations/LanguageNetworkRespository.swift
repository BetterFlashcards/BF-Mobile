//
//  LanguageNetworkRespository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

class LanguageNetworkRepository: BaseAuthenticatedNetworking, LanguageRepositoryProtocol {
    let languageRequests = LanguageRequests.self

    func fetch(at pagination: Pagination) async throws -> PaginatedList<Language> {
        let result = try await client.make(request: languageRequests.list(), headers: try await headers(), queries: PaginationQueryDTO(pagination: pagination)).data
        return .init(items: result.items, count: result.count, pagination: pagination)
    }
}
