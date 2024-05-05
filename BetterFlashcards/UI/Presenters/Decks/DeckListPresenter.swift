//
//  DeckListViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 21/04/2024.
//

import Foundation
import Combine

class DeckListPresenter: PaginatedListViewPresenterProtocol, ObservableObject {
    @Published var viewModel = ListViewModel<Deck>()
    let pageSize = 20
    
    private let deckService: any DeckServiceProtocol
    private var cancelSet: Set<AnyCancellable> = []
    
    init(deckService: any DeckServiceProtocol) {
        self.deckService = deckService
    }
    
    func setup() {
        deckService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }
    
    func addTapped() {
        viewModel.sheet = .deckCreation
    }
    
    func getFullList() async throws -> [Deck] {
        try await deckService.getList()
    }
    
    func getPaginatedList(at pagination: Pagination) async throws -> PaginatedList<Deck> {
        try await deckService.getList(at: pagination)
    }
    
    func delete(_ deck: Deck) async throws -> Deck {
        try await deckService.delete(deck)
    }
   
    private func handle(_ event: DeckServiceEvent) {
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

