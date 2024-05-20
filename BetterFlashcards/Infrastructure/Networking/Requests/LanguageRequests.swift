//
//  LanguageRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation
import APIClient

enum LanguageRequests {
    static let group = NetworkConstants.baseGroup.subgroup(path: NetworkConstants.languagesPath)
    
    // MARK: Subgroups
    static func list() -> PaginatedAuthRequest<Language> {
        group.request(path: "")
    }
}
