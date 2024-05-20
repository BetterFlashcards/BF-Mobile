//
//  LanguageRepositoryProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

protocol LanguageRepositoryProtocol {
    func fetch(at pagination: Pagination) async throws -> PaginatedList<Language>
}
