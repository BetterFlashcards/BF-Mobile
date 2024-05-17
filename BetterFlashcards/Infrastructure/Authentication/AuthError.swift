//
//  AuthError.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

enum AuthError: Error {
    case tokenUnavailable
    case expired
}
