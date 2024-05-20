//
//  CardListViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

extension ListViewModel where Item == FlashCard {
    var hasDrafts: Bool { list.contains { $0.isDraft } }
    var hasCards: Bool { list.contains { !$0.isDraft } }
}
