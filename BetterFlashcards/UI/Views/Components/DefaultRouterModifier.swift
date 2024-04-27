//
//  DefaultRouterModifier.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case bookList
    case bookDetails(Book)
    case deckList
    case deckDetails(Deck)
}

enum SheetDestination: Hashable, Identifiable {
    case homeScreen
    case bookCreation
    case deckCreation
    
    var id: Int { self.hashValue }
}

private struct DefaultRouterModifier<V: BaseViewModel>: ViewModifier {
    @ObservedObject var viewModel: V
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .bookList:
                    BookListScreen()
                case .bookDetails(let book):
                    Text("Book details for \(book.title)")
                case .deckList:
                    DeckListScreen()
                case .deckDetails(let deck):
                    Text("Deck details for \(deck.name)")
                    // DeckDetailScreen(deck: deck)
                    
                }
            }
            .sheet(item: $viewModel.sheet, content: view(for:))
            .fullScreenCover(item: $viewModel.fullScreen, content: view(for:))
    }
    
    @ViewBuilder
    func view(for sheet: SheetDestination) -> some View {
        switch sheet {
        case .homeScreen:
            HomeScreen()
        case .bookCreation:
            Text("Book creation")
        case .deckCreation:
            Text("Deck creation")
            // DeckDetailScreen(deck: nil)
        }
    }
}

extension NavigationLink where Destination == Never {
    init(to destination: NavigationDestination, label: () -> Label) {
        self.init(value: destination, label: label)
    }
}


@MainActor
extension View {
    func withDefaultRouter<V>(viewModel: V) -> some View where V: BaseViewModel {
        modifier(DefaultRouterModifier(viewModel: viewModel))
    }
}
