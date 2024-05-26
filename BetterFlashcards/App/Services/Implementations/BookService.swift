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
    private let fileManager: FileManager = .default
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
    
    func expectedURL(for book: Book) throws -> URL {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ErrorDTO(detail: "Unable to import file", message: "Documents directory not found")
        }
        let destinationURL = documentsDirectory
            .appending(path: "\(book.id)-\(book.author)-\(book.title)")
            .appendingPathExtension(for: .pdf)
        return destinationURL
    }
    
    func existingURL(for book: Book) -> URL? {
        guard let expectedURL = try? expectedURL(for: book) else { return nil }
        if fileManager.fileExists(atPath: expectedURL.path) {
            return expectedURL
        } else {
            return nil
        }
    }
    
    func importFile(at url: URL, for book: Book) throws -> URL {
        let destinationURL = try expectedURL(for: book)
        if url.startAccessingSecurityScopedResource() {
            defer { url.stopAccessingSecurityScopedResource() }
            try fileManager.copyItem(at: url, to: destinationURL)
        }
        return destinationURL
    }
}
