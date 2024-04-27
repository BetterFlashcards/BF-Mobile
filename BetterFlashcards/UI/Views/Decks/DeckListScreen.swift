//
//  DeckListView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 21/04/2024.
//

import SwiftUI
import GRDBQuery

struct DeckListScreen: View {
    @EnvironmentStateObject var presenter: DeckListPresenter
    
    init() {
        _presenter = EnvironmentStateObject { env in
            DeckListPresenter(deckService: env.deckService)
        }
    }
    
    var body: some View {
        NavigationStack {
            ListView(presenter: presenter) { deck in
                NavigationLink(to: .deckDetails(deck)) {
                    DeckCellView(deck: deck)
                }
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") { presenter.addTapped() }
                }
            }.withDefaultRouter(viewModel: presenter.viewModel)
            .navigationTitle("Decks")
        }
    }
}
