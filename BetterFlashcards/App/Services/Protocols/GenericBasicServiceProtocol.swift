//
//  GenericBasicServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

protocol GenericBasicServiceProtocol<Item, Event> {
    associatedtype Item
    associatedtype Event
    var eventPublisher: AnyPublisher<Event, Never> { get }
    func getList() async throws -> [Item]
    func create(_: Item) async throws -> Item
    func update(_: Item) async throws -> Item
    func delete(_: Item) async throws -> Item
}
