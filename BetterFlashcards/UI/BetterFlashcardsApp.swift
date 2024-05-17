//
//  BetterFlashcardsApp.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI
import DIContainer

@main
struct BetterFlashcardsApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(\.di, DIContainer().withDefaultDependencyGraph())
        }
    }
}
