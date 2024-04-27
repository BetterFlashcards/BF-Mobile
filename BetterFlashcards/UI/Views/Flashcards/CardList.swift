//
//  CardList.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI
import GRDBQuery

struct CardList: View {
    @EnvironmentStateObject var presenter: FlashCardListPresenter
    
    init(for deckID: Deck.ID) {
        _presenter = EnvironmentStateObject { env in
            FlashCardListPresenter(flashCardService: env.flashcardService, deckID: deckID)
        }
    }
    
    var body: some View {
        NavigationStack {
            CardGrid(presenter: presenter)
                .navigationTitle("Cards")
                .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
    
    struct CardGrid: View {
        let presenter: FlashCardListPresenter
        @ObservedObject var viewModel: ListViewModel<FlashCard>
        
        init(presenter: FlashCardListPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.list) { card in
                        cell(for: card)
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }.task { await presenter.firstLoad() }
        }
        
        func cell(for card: FlashCard) -> some View {
            FlashCardGridCell(flashCard: card)
                .contextMenu {
                    NavigationLink(to: .cardDetails(card)) {
                        Text("Edit")
                    }
                    Button("Delete") { presenter.delete(card) }
                        .foregroundColor(.red)
                }
        }
    }
}


