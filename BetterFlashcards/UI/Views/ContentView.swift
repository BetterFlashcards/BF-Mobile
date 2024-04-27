//
//  ContentView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                DeckListView()
                    .tabItem {
                        Label("Library", systemImage: "rectangle.on.rectangle.angled")
                    }
                BookListView()
                    .tabItem {
                        Label("Books", systemImage: "book")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
