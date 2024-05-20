//
//  FlashCardDetailPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FlashCardDetailPresenter: ObservableObject {
    @Published var viewModel: FlashCardViewModel

    private let flashCardService: any FlashCardServiceProtocol
    private let dismiss: DismissAction
    private var cancelSet: Set<AnyCancellable> = []
    
    init(
        card: FlashCard? = nil,
        deckID: Deck.ID,
        flashCardService: any FlashCardServiceProtocol,
        dismiss: DismissAction
    ) {
        if let card {
            self.viewModel = FlashCardViewModel(from: card)
        } else {
            self.viewModel = FlashCardViewModel(deckID: deckID)
        }
        
        self.flashCardService = flashCardService
        self.dismiss = dismiss
    }
    
    func setup() async {
        flashCardService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }
    
    func save(isDraft: Bool) {
        viewModel.isDraft = isDraft
        let card = viewModel.toCard()
        let id = viewModel.id
        Task {
            if id != nil {
                await update(card: card)
            } else {
                await create(card: card)
                dismiss()
            }
        }
    }
    
    func practice() {
        guard let deckID = viewModel.id else { return }
        viewModel.sheet = .practice(for: deckID)
    }
    
    func create(card: FlashCard) async {
        do {
            viewModel.isLoading = true
            let card = try await flashCardService.create(card)
            viewModel.id = card.id
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func update(card: FlashCard) async {
        do {
            viewModel.isLoading = true
            _ = try await flashCardService.update(card)
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func delete() {
        guard viewModel.id != nil else { return }
        let card = viewModel.toCard()
        Task {
            
            do {
                _ = try await flashCardService.delete(card)
            } catch {
                viewModel.error = ViewError(error: error)
            }
        }
    }
    
    
    func handle(_ event: FlashCardServiceEvent) {
        switch event {
        case .updated(let card) where card.id == self.viewModel.id:
            viewModel.frontText = card.frontWord
            viewModel.backText = card.backWord
        case .deleted(let card) where card.id == self.viewModel.id:
            dismiss()
        default:
            break
        }
    }
}
