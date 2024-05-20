//
//  BookRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum BookRequests {
    static let group = NetworkConstants.baseGroup.subgroup(path: NetworkConstants.bookPath)
    
    // MARK: Subgroups
    static func detailsGroup(for bookID: Book.ID) -> any GroupProtocol {
        group.subgroup(path: "/\(bookID)")
    }
    
    // MARK: Top Level
    static func list() -> PaginatedAuthRequest<Book> {
        group.request(path: "")
    }
    
    static func create() -> AuthenticatedRequest<CreateBookDTO, Book, ErrorDTO> {
        group.request(path: "", method: .post)
    }
    
    // MARK: Details
    static func details(for bookID: Book.ID) -> AuthenticatedRequest<Nothing, Book, ErrorDTO> {
        detailsGroup(for: bookID).request(path: "")
    }

    static func update(at bookID: Book.ID) -> AuthenticatedRequest<Book, Book, ErrorDTO> {
        detailsGroup(for: bookID).request(path: "", method: .put)
    }
    
    static func delete(at bookID: Book.ID) -> AuthenticatedRequest<Nothing, Nothing?, ErrorDTO> {
        detailsGroup(for: bookID).request(path: "", method: .delete)
    }
}
