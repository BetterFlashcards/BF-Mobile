//
//  ContentView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI
import GRDBQuery

struct HomeScreen: View {
    @EnvironmentStateObject var presenter: HomePresenter
    
    init() {
        self._presenter = EnvironmentStateObject {
            HomePresenter(auth: $0.auth)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink(to: .deckList) {
                        Label("Library", systemImage: "rectangle.on.rectangle.angled")
                    }
                    NavigationLink(to: .bookList) {
                        Label("Books", systemImage: "book")
                    }
                }
                Button("Logout") { presenter.logout() }
                    .buttonStyle(.borderedProminent)
            }.navigationBarTitle("Better Flashcards")
            .navigationBarTitleDisplayMode(.large)
            .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
