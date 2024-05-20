//
//  BookService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

class BookService: BookServiceProtocol {
    private let bookRepo: any BookRepositoryProtocol
    private let eventSubject = PassthroughSubject<BookServiceEvent, Never>()
    
    var eventPublisher: AnyPublisher<BookServiceEvent, Never> {
        self.eventSubject.eraseToAnyPublisher()
    }
    
    init(bookRepo: any BookRepositoryProtocol) {
        self.bookRepo = bookRepo
    }
    
    func getList(at pagination: Pagination) async throws -> PaginatedList<Book> {
        try await bookRepo.fetch(at: pagination)
    }
    
    func create(_ book: Book) async throws -> Book {
        let book = try await bookRepo.create(book: book)
        eventSubject.send(.added(book))
        return book
    }
    
    func update(_ book: Book) async throws -> Book {
        let book = try await bookRepo.update(book: book)
        eventSubject.send(.updated(book))
        return book
    }
    
    func delete(_ book: Book) async throws -> Book {
        try await bookRepo.delete(book: book)
        eventSubject.send(.deleted(book))
        return book
    }
}
