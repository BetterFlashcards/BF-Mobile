//
//  PaginationQueryDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation
import APIClient

struct PaginationQueryDTO {
    let offset: Int
    let limit: Int?
    
    init(offset: Int, limit: Int?) {
        self.offset = offset
        self.limit = limit
    }
    
    init(pagination: Pagination) {
        self.offset = pagination.page * pagination.size
        self.limit = pagination.size
    }
}

extension PaginationQueryDTO: StringKeyValueConvertible {
    func keyValues() -> [KeyValuePair<String>] {
        var keyValues = [ ("offset", "\(offset)") ]
        if let limit {
            keyValues.append(("limit", "\(limit)"))
        }
        return keyValues
    }
}
