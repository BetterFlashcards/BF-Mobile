//
//  FlashCardListPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

class FlashCardListPresenter: PaginatedListViewPresenterProtocol, ObservableObject {
    let pageSize = 20
    
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
        viewModel.sheet = .cardCreation(in: deckID)
    }
    
    func getPaginatedList(at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        try await flashCardService.getList(for: deckID, at: pagination)
    }
    
    func delete(_ flashCard: FlashCard) async throws -> FlashCard {
        try await flashCardService.delete(flashCard)
    }
    
    func delete(_ flashCard: FlashCard) {
        Task {
            do {
                _ = try await delete(flashCard)
            } catch {
                viewModel.error = ViewError(error: error)
            }
        }
    }
   
    private func handle(_ event: FlashCardServiceEvent) {
        switch event {
        case .added(let card):
            viewModel.list.append(card)
        case .updated(let card):
            viewModel.list[id: card.id] = card
        case .deleted(let card):
            viewModel.list.remove(id: card.id)
        }
    }
}


