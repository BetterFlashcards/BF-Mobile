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
    static let authPath = "/api/auth"
    static let loginPath = "/login"
    static let register = "/register"
    static let deckPath = "/api/decks"
    static let flashCardPath = "/api/cards"
    static let deckCardsPath = "/cards"
    static let deckCardsDuePath = "/due-cards"
    static let updateReviewPath = "/update_review_data"
    static let bookPath = "/api/books"
}

extension NetworkConstants {
    static var baseGroup: GroupProtocol {
        Group(scheme: scheme, host: baseURL, port: nil, path: "")
    }
}
