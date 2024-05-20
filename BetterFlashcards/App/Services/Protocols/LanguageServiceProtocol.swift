//
//  LanguageServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

protocol LanguageServiceProtocol {
    func getList(at: Pagination) async throws -> PaginatedList<Language>
}
