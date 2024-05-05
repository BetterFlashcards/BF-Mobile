//
//  ListDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation

struct ListDTO<Item> {
    let items: [Item]
    let count: Int
}

extension ListDTO: Codable where Item: Codable { }
