//
//  GenericBasicServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

protocol GenericBasicServiceProtocol<Item> {
    associatedtype Item
    var eventPublisher: AnyPublisher<BasicServiceEvent<Item>, Never> { get }
    func getList() async throws -> [Item]
    func getList(at: Pagination) async throws -> PaginatedList<Item>
    func create(_: Item) async throws -> Item
    func update(_: Item) async throws -> Item
    func delete(_: Item) async throws -> Item
}

enum BasicServiceEvent<T> {
    case added(T)
    case updated(T)
    case deleted(T)
}
