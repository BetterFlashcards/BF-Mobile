//
//  BookNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class BookNetworkRepository: BaseAuthenticatedNetworking, BookRepositoryProtocol {
    let bookRequests = BookRequests.self
    
    func fetchAll() async throws -> [Book] {
        let result = await client.make(request: bookRequests.list(), headers: try await headers())
        return try convertResult(result: result)
    }
    
    func fetch(by bookID: Book.ID) async throws -> Book? {
        let result = await client.make(request: bookRequests.details(for: bookID), headers: try await headers())
        return try convertResult(result: result)
    }
 
    func create(book: Book) async throws -> Book {
        let result = await client.make(request: bookRequests.create(), body: book, headers: try await headers())
        return try convertResult(result: result)
    }
    
    func update(book: Book) async throws -> Book {
        let result = await client.make(request: bookRequests.update(at: book.id), body: book, headers: try await headers())
        return try convertResult(result: result)
    }
    
    func delete(book: Book) async throws -> Book {
        let result = await client.make(request: bookRequests.delete(at: book.id), headers: try await headers())
        return try convertResult(result: result)
    }

}
