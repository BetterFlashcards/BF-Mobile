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
    case languagePicker(onSelect: (Language) -> Void, id: UUID = UUID())
    case translation(String, onSelect: (Translation) -> Void)
}

extension NavigationDestination: Identifiable {
    var id: String {
        switch self {
        case .bookList:
            return "BookList"
        case .bookDetails(let book):
            return "BookDetails-\(book.id)"
        case .deckList:
            return "DeckList"
        case .deckDetails(let deck):
            return "DeckDetails-\(deck.id)"
        case .cardDetails(let card):
            return "CardDetails-\(card.id)"
        case .languagePicker(_, let id):
            return "LanguagePicker-\(id)"
        case .translation(let word, _):
            return "Translation-\(word)"
        }
    }
    
    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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
                    BookDetailScreen(book: book)
                case .deckList:
                    DeckListScreen()
                case .deckDetails(let deck):
                    DeckDetailScreen(deck: deck)
                case .cardDetails(let card):
                    FlashCardDetailScreen(card: card)
                case .languagePicker(let selectLanguage, _):
                    LanguagePicker(onSelect: selectLanguage)
                case .translation(let word, let selectTranslation):
                    TranslationScreen(word: word, onSelect: selectTranslation)
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
            BookDetailScreen()
        case .deckCreation:
            DeckDetailScreen()
        case .cardCreation(let deckID):
            NavigationStack {
                FlashCardDetailScreen(in: deckID)
            }
        case .cardList(let deckID):
            CardList(for: deckID)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        case .practice(let deckID):
            PracticeScreen(for: deckID)
                .presentationDetents([.fraction(1)])
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
