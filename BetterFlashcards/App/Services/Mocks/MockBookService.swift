//
//  MockBookService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

actor MockBookService: BookServiceProtocol {
    private var bookList = (0...100).map {
        Book(id: $0, title: "Book \($0)", author: "Author \($0)")
    }
    private let eventSubject = PassthroughSubject<BookServiceEvent, Never>()
    private let pageSize = 20
    
    nonisolated var eventPublisher: AnyPublisher<BookServiceEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func getList() async throws -> [Book] {
        return bookList
    }
    
    func getList(at page: Int) async throws -> [Book] {
        let start = page * pageSize
        let end = min(start + pageSize, bookList.count)
        guard start < end else { return [] }
        return Array(bookList[start..<end])
    }
    
    func create(_ book: Book) async throws -> Book {
        bookList.append(book)
        eventSubject.send(.added(book))
        return book
    }
    
    func update(_ book: Book) async throws -> Book {
        guard let index = bookList.firstIndex(where: { $0.id == book.id })
        else {
            throw ServiceError.notFound
        }
        bookList[index] = book
        eventSubject.send(.updated(book))
        return book
    }
    
    func delete(_ book: Book) async throws -> Book {
        guard let index = bookList.firstIndex(where: { $0.id == book.id })
        else {
            throw ServiceError.notFound
        }
        bookList.remove(at: index)
        eventSubject.send(.deleted(book))
        return book
    }
    
}