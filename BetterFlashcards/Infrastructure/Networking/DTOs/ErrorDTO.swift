//
//  ErrorDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 18/05/2024.
//

import Foundation
import APIClient

struct ErrorDTO: Codable {
    let detail: String
    let message: String?
}

extension ErrorDTO: LocalizedError {
    var errorDescription: String? { self.detail }
}
