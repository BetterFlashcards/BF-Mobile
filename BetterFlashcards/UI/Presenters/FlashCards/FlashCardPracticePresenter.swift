//
//  FlashCardPracticePresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation
import SwiftUI

@MainActor
class FlashCardPracticePresenter: ObservableObject {
    let pageSize = 20
    
    @Published var viewModel = PracticeListViewModel()
    let deckID: Deck.ID
    
    private let flashCardService: any FlashCardServiceProtocol
    private let dismiss: DismissAction
    
    init(
        flashCardService: any FlashCardServiceProtocol,
        deckID: Deck.ID,
        dismiss: DismissAction
    ) {
        self.flashCardService = flashCardService
        self.deckID = deckID
        self.dismiss = dismiss
    }
    
    func firstLoad() async {
        await load(page: 0)
        viewModel.nextCard()
    }
    
    func load(page: Int) async {
        do {
            viewModel.isLoading = true
            let pagination = Pagination(page: page, size: self.pageSize)
            let result = try await flashCardService.getList(for: deckID, at: pagination)
            viewModel.list.append(contentsOf: result.items)
            viewModel.currentPage = result.pagination.page
            viewModel.hasNextPage = result.hasNextPage
        } catch {
            viewModel.error = ViewError(error: error)
        }
        viewModel.isLoading = false
    }
    
    func onFlipTapped(for item: PracticeItemViewModel) {
        item.flipped.toggle()
    }
    
    func onRemembered(item: PracticeItemViewModel) {
        log(FlashCardPractice(flashCardID: item.card.id, result: .memorized))
    }
    
    func onForgotten(item: PracticeItemViewModel) {
        log(FlashCardPractice(flashCardID: item.card.id, result: .forgotten))
    }
    
    func completed() {
        self.dismiss()
    }
    
    private func log(_ practice: FlashCardPractice) {
        Task {
            try await self.flashCardService.save(practice: practice)
            self.viewModel.currentItem?.flipped = false
            self.viewModel.nextCard()
            if self.viewModel.currentItem?.card.id == self.viewModel.list.last?.id {
                await self.load(page: self.viewModel.currentPage+1)
            }
        }
    }
}
