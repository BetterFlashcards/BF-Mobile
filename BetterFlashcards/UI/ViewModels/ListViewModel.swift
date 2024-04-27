//
//  ListViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 22/04/2024.
//

import Foundation
import IdentifiedCollections

@MainActor
class ListViewModel<Item: Identifiable>: ObservableObject {
    var currentPage = 0
    var hasNextPage = true
    @Published var list: IdentifiedArrayOf<Item> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
}
