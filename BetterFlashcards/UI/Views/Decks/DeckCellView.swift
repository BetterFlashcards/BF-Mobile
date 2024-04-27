//
//  DeckCellView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct DeckCellView: View {
    let deck: Deck
    var body: some View {
        VStack(alignment: .leading) {
            Text(deck.name)
            if let language = deck.language, !language.isEmpty {
                Text(language)
            }
        }
    }
}

