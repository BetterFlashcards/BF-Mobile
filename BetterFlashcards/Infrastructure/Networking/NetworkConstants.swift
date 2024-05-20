//
//  NetworkingConstants.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum NetworkConstants {
    static let scheme = "http"
    static let baseURL = "18.234.173.119"
    static let registerPath = "/api/user/register"
    static let authPath = "/api/token"
    static let loginPath = "/pair"
    static let refreshPath = "/refresh"
    static let verifyPath = "/verify"
    static let deckPath = "/api/decks"
    static let flashCardPath = "/api/cards"
    static let deckCardsPath = "/cards"
    static let deckCardsDuePath = "/due-cards"
    static let updateReviewPath = "/set-state"
    static let bookPath = "/api/books"
    static let languagesPath = "/api/languages"
}

extension NetworkConstants {
    static var baseGroup: GroupProtocol {
        Group(scheme: scheme, host: baseURL, port: nil, path: "")
    }
}
