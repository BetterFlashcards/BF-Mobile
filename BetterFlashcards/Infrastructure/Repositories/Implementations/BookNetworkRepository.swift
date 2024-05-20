//
//  BookNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class BookNetworkRepository: BaseAuthenticatedNetworking, BookRepositoryProtocol {
    let bookRequests = BookRequests.self
    
    func fetch(at pagination: Pagination) async throws -> PaginatedList<Book> {
        let result = try await client.make(request: bookRequests.list(), headers: try await headers(), queries: PaginationQueryDTO(pagination: pagination)).data
        return .init(items: result.items, count: result.count, pagination: pagination)
    }
    
    func fetch(by bookID: Book.ID) async throws -> Book? {
        try await client.make(request: bookRequests.details(for: bookID), headers: try await headers()).data
    }
 
    func create(book: Book) async throws -> Book {
        let dto = CreateBookDTO(title: book.title, author: book.author)
        return try await client.make(request: bookRequests.create(), body: dto, headers: try await headers()).data
    }
    
    func update(book: Book) async throws -> Book {
        try await client.make(request: bookRequests.update(at: book.id), body: book, headers: try await headers()).data
    }
    
    func delete(book: Book) async throws {
        _ = try await client.make(request: bookRequests.delete(at: book.id), headers: try await headers())
    }

}
