//
//  LanguageRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation
import APIClient

enum LanguageRequests {
    static func list() -> PaginatedAuthRequest<Language> {
        NetworkConstants.baseGroup.request(path: NetworkConstants.languagesPath)
    }
    
    typealias TranslationRequest = AdvancedRequest<Nothing, BearerHeaders<[String: String]>, TranslationLanguageQueries, [Translation], ErrorDTO>

    static func translate(word: String) ->  TranslationRequest{
        NetworkConstants.baseGroup
            .subgroup(path: NetworkConstants.translationPath)
            .request(path: "\(word)")
    }
}
