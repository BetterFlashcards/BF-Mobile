//
//  BookRepositoryProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchAll() async throws -> [Book]
    func fetch(by bookID: Book.ID) async throws -> Book?
    func create(book: Book) async throws -> Book
    func update(book: Book) async throws -> Book
    func delete(book: Book) async throws -> Book
}
