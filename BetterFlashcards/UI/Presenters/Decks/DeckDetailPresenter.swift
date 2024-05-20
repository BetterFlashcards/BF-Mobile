//
//  DeckDetailPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DeckDetailPresenter: ObservableObject {
    @Published var viewModel: DeckViewModel

    private let deckService: any DeckServiceProtocol
    private let flashCardService: any FlashCardServiceProtocol
    private let dismiss: DismissAction
    private var cancelSet: Set<AnyCancellable> = []
    
    init(
        deck: Deck? = nil,
        deckService: any DeckServiceProtocol,
        flashCardService: any FlashCardServiceProtocol,
        dismiss: DismissAction
    ) {
        self.viewModel = DeckViewModel(id: deck?.id, name: deck?.name ?? "", language: deck?.language ?? "")
        self.deckService = deckService
        self.flashCardService = flashCardService
        self.dismiss = dismiss
    }
    
    func setup() async {
        deckService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
        await self.load()
    }
    
    func load() async {
        guard let deckID = viewModel.id else { return }
        viewModel.isLoading = true
        let cards = try? await flashCardService.getList(for: deckID, at: Pagination(page: 0, size: 1))
        viewModel.isLoading = false
        viewModel.cardCount = cards?.count ?? 0
    }
    
    func save() {
        let deck = viewModel.toDeck()
        let id = viewModel.id
        Task {
            if id != nil {
                await update(deck: deck)
            } else {
                await create(deck: deck)
                dismiss()
            }
        }
    }
    
    func practice() {
        guard let deckID = viewModel.id else { return }
        viewModel.sheet = .practice(for: deckID)
    }
    
    func create(deck: Deck) async {
        do {
            viewModel.isLoading = true
            let deck = try await deckService.create(deck)
            viewModel.id = deck.id
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func update(deck: Deck) async {
        do {
            viewModel.isLoading = true
            _ = try await deckService.update(deck)
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func delete() {
        guard viewModel.id != nil else { return }
        let deck = viewModel.toDeck()
        Task {
            
            do {
                _ = try await deckService.delete(deck)
            } catch {
                viewModel.error = ViewError(error: error)
            }
        }
    }
    
    func viewCardsTapped() {
        guard let deckID = viewModel.id else { return }
        viewModel.sheet = .cardList(for: deckID)
    }
    
    func handle(_ event: DeckServiceEvent) {
        switch event {
        case .updated(let deck) where deck.id == self.viewModel.id:
            viewModel.name = deck.name
            viewModel.language = deck.language ?? ""
        case .deleted(let deck) where deck.id == self.viewModel.id:
            dismiss()
        default:
            break
        }
    }
}
