//
//  MockLanguageService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

actor MockLanguageService: LanguageServiceProtocol {
    private var languageList = [
        Language(id: 1, name: "English", nameLocal: "English", isocode: "en", sorting: 0),
        Language(id: 2, name: "Arabic", nameLocal: "Arabic", isocode: "ar", sorting: 1),
        Language(id: 3, name: "French", nameLocal: "French", isocode: "fr", sorting: 2)
    ]
    
    
    func getList(at pagination: Pagination) async throws -> PaginatedList<Language> {
        let start = pagination.page * pagination.size
        let end = min(start + pagination.size, languageList.count)
        guard start < end else { return .init(items: [], count: 0, pagination: pagination) }
        return .init(items: Array(languageList[start..<end]), count: languageList.count, pagination: pagination)
    }
    
    func translate(word: String, from source: Language, to target: Language) async throws -> [Translation] {
        [Translation(word: word, translation: String(word.reversed()))]
    }
}
