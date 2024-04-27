//
//  BookRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum BookRequests {
    static let group = Group(host: NetworkConstants.baseURL, path: NetworkConstants.bookPath)
    
    // MARK: Subgroups
    static func detailsGroup(for bookID: Book.ID) -> any GroupProtocol {
        group.subgroup(path: "/\(bookID)")
    }
    
    // MARK: Top Level
    static func list() -> AuthenticatedRequest<Nothing, [Book]> {
        group.request(path: "/")
    }
    
    static func create() -> AuthenticatedRequest<Book, Book> {
        group.request(path: "/", method: .post)
    }
    
    // MARK: Details
    static func details(for bookID: Book.ID) -> AuthenticatedRequest<Nothing, Book> {
        detailsGroup(for: bookID).request(path: "/")
    }

    static func update(at bookID: Book.ID) -> AuthenticatedRequest<Book, Book> {
        detailsGroup(for: bookID).request(path: "/", method: .put)
    }
    
    static func delete(at bookID: Book.ID) -> AuthenticatedRequest<Nothing, Book> {
        detailsGroup(for: bookID).request(path: "/", method: .delete)
    }
}