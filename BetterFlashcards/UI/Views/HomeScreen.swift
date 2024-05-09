//
//  ContentView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.auth) var auth

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(
                    destination: { DeckListScreen() } ,
                    label: { Label("Library", systemImage: "rectangle.on.rectangle.angled") }
                )
                NavigationLink(
                    destination: { BookListScreen() } ,
                    label: { Label("Books", systemImage: "book") }
                )
                Button("Logout") {
                    Task { await auth.logout() }
                }
            }.navigationBarTitle("Better Flashcards")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
