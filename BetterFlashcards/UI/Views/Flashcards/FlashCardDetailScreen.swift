//
//  FlashCardDetailScreen.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import SwiftUI
import GRDBQuery

struct FlashCardDetailScreen: View {
    @EnvironmentStateObject var presenter: FlashCardDetailPresenter
    
    init(card: FlashCard) {
        _presenter = EnvironmentStateObject { env in
            FlashCardDetailPresenter(
                card: card,
                deckID: card.deckID,
                flashCardService: env.flashcardService,
                dismiss: env.dismiss
            )
        }
    }
    
    init(in deckID: Deck.ID) {
        _presenter = EnvironmentStateObject { env in
            FlashCardDetailPresenter(
                card: nil,
                deckID: deckID,
                flashCardService: env.flashcardService,
                dismiss: env.dismiss
            )
        }
    }
    
    var body: some View {
        MainView(presenter: presenter)
            .task { await presenter.setup() }
    }
    
    private struct MainView: View {
        let presenter: FlashCardDetailPresenter
        @ObservedObject var viewModel: FlashCardViewModel
        
        init(presenter: FlashCardDetailPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            VStack {
                Form {
                    FormLabelledField(label: "Front") {
                        TextField("Front", text: $viewModel.frontText)
                    }
                    
                    FormLabelledField(label: "Back") {
                        TextField("Back", text: $viewModel.backText)
                    }
                    
                    if !viewModel.frontText.isEmpty {
                        NavigationLink(to: .translation(viewModel.frontText, onSelect: { presenter.accept(translation: $0)})) {
                            Text("Translate")
                                .foregroundColor(.blue)
                        }
                    }
                }

                Button("Save") { presenter.save(isDraft: false) }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.canSave)
                
                Button("Save as Draft") { presenter.save(isDraft: true) }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.canSaveDraft)
                
                Button("Delete") { presenter.delete() }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
            }
            .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
}

