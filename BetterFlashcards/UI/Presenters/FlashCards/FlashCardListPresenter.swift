//
//  FlashCardListPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

class FlashCardListPresenter: ListViewPresenterProtocol, ObservableObject {
    @Published var viewModel = ListViewModel<FlashCard>()
    let deckID: Deck.ID
    
    private let flashCardService: any FlashCardServiceProtocol
    private var cancelSet: Set<AnyCancellable> = []
    
    init(flashCardService: any FlashCardServiceProtocol, deckID: Deck.ID) {
        self.flashCardService = flashCardService
        self.deckID = deckID
    }
    
    func setup() {
        flashCardService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }
    
    func addTapped() {
        viewModel.sheet = .cardCreation
    }
    
    func getFullList() async throws -> [FlashCard] {
        try await flashCardService.getList(for: deckID)
    }
    
    func getList(at page: Int) async throws -> [Deck] {
        // try await deckService.getList(at: page)
        []
    }
    
    func delete(_ flashCard: FlashCard) async throws -> FlashCard {
        try await flashCardService.delete(flashCard)
    }
    
    func delete(_ flashCard: FlashCard) {
        Task {
            do {
                _ = try await delete(flashCard)
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }
   
    private func handle(_ event: FlashCardServiceEvent) {
        switch event {
        case .added(let deck):
            viewModel.list.append(deck)
        case .updated(let deck):
            viewModel.list[deck.id] = deck
        case .deleted(let deck):
            viewModel.list.remove(id: deck.id)
        }
    }
}


