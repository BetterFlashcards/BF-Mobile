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
    private let dismiss: DismissAction
    private var cancelSet: Set<AnyCancellable> = []
    
    init(
        deck: Deck? = nil,
        deckService: any DeckServiceProtocol,
        dismiss: DismissAction
    ) {
        self.viewModel = DeckViewModel(id: deck?.id, name: deck?.name ?? "", language: deck?.language ?? "")
        self.deckService = deckService
        self.dismiss = dismiss
    }
    
    func setup()  {
        deckService.eventPublisher
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }
    
    func save() {
        let deck = Deck(id: viewModel.id ?? -1, name: viewModel.name, language: viewModel.language)
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
    
    func create(deck: Deck) async {
        do {
            viewModel.isLoading = true
            let deck = try await deckService.create(deck)
            viewModel.id = deck.id
            viewModel.isLoading = false
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
    }
    
    func update(deck: Deck) async {
        do {
            viewModel.isLoading = true
            _ = try await deckService.update(deck)
            viewModel.isLoading = false
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
    }
    
    func delete() {
        guard let id = viewModel.id else { return }
        Task {
            let deck = Deck(id: id, name: viewModel.name, language: viewModel.language)
            do {
                _ = try await deckService.delete(deck)
                dismiss()
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
        }
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
