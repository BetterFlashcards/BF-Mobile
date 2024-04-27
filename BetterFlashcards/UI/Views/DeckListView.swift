//
//  DeckListView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 21/04/2024.
//

import SwiftUI
import GRDBQuery

struct DeckListView: View {
    @EnvironmentStateObject var presenter: DeckListPresenter
    
    init() {
        _presenter = EnvironmentStateObject { env in
            DeckListPresenter(deckService: env.deckService)
        }
    }
    
    var body: some View {
        ListView(presenter: presenter) { deck in
            DeckCellView(deck: deck)
        }
        .navigationTitle("Decks")
    }
}

