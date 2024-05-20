//
//  LanguageService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

class LanguageService: LanguageServiceProtocol {
    private let languageRepo: any LanguageRepositoryProtocol
    
    init(languageRepo: LanguageRepositoryProtocol) {
        self.languageRepo = languageRepo
    }

    func getList(at pagination: Pagination) async throws -> PaginatedList<Language> {
        try await languageRepo.fetch(at: pagination)
    }
}
