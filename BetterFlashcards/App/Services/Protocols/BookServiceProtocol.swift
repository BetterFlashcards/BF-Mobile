//
//  BookServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol BookServiceProtocol: GenericBasicServiceProtocol where Item == Book {
    func existingURL(for book: Book) -> URL?
    func importFile(at url: URL, for book: Book) async throws -> URL
}

typealias BookServiceEvent = BasicServiceEvent<Book>
