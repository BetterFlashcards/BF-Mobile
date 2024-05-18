//
//  BaseViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import SwiftUI

struct ViewError: LocalizedError {
    let underlyingError: Error
    let id = UUID()
    
    var errorDescription: String? { (underlyingError as? LocalizedError)?.errorDescription }
    
    init(error: Error) {
        self.underlyingError = error
    }
}

@MainActor
class BaseViewModel: ObservableObject {
    @Published var sheet: SheetDestination?
    @Published var fullScreen: SheetDestination?
    @Published var error: ViewError?
    
    init(sheet: SheetDestination? = nil, fullScreen: SheetDestination? = nil, error: ViewError? = nil) {
        self.sheet = sheet
        self.fullScreen = fullScreen
        self.error = error
    }
    
    var isErrorPresentedBinding: Binding<Bool> {
        Binding<Bool>(
            get: { self.error != nil },
            set: { if !$0 { self.error = nil }}
        )
    }
}
