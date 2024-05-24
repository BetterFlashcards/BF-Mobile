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
    
    func translate(word: String, from source: Language, to target: Language) async throws -> [Translation] {
        try await client.make(
            request: languageRequests.translate(word: word),
            headers: try await headers(),
            queries: TranslationLanguageQueries(source: source, target: target)
        ).data
    }
    
}
