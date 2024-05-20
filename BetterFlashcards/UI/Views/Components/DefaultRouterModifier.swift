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
    case cardDetails(FlashCard)
}

enum SheetDestination: Hashable, Identifiable {
    case homeScreen
    case bookCreation
    case deckCreation
    case cardCreation(in: Deck.ID)
    case cardList(for: Deck.ID)
    case practice(for: Deck.ID)
    
    var id: Int { self.hashValue }
}

private struct DefaultRouterModifier<V: BaseViewModel>: ViewModifier {
    @ObservedObject var viewModel: V
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: viewModel.isErrorPresentedBinding, error: viewModel.error) {
                Button("OK") { }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .bookList:
                    BookListScreen()
                case .bookDetails(let book):
                    Text("Book details for \(book.title)")
                case .deckList:
                    DeckListScreen()
                case .deckDetails(let deck):
                    DeckDetailScreen(deck: deck)
                case .cardDetails(let card):
                    FlashCardDetailScreen(card: card)
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
            DeckDetailScreen()
        case .cardCreation(let deckID):
            FlashCardDetailScreen(in: deckID)
        case .cardList(let deckID), .practice(let deckID):
            CardList(for: deckID)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
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
