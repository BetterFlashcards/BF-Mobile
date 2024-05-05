//
//  PaginatedList.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation

struct Pagination {
    let page: Int
    let size: Int
}

struct PaginatedList<Item> {
    let items: [Item]
    let count: Int
    let pagination: Pagination
    
    var hasNextPage: Bool {
        count > ((pagination.page + 1) * pagination.size) 
    }
}
