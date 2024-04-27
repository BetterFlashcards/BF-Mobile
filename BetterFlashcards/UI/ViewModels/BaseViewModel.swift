//
//  BaseViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

@MainActor
class BaseViewModel: ObservableObject {
    @Published var sheet: SheetDestination? = nil
    @Published var fullScreen: SheetDestination? = nil
}
