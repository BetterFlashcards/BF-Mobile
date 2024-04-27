//
//  ContentView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        TabView {
            DeckListScreen()
                .tabItem {
                    Label("Library", systemImage: "rectangle.on.rectangle.angled")
                }
            BookListScreen()
                .tabItem {
                    Label("Books", systemImage: "book")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
