//
//  DeckDetailScreen.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI
import GRDBQuery

struct DeckDetailScreen: View {
    @EnvironmentStateObject var presenter: DeckDetailPresenter
    
    init(deck: Deck? = nil) {
        _presenter = EnvironmentStateObject { env in
            DeckDetailPresenter(
                deck: deck,
                deckService: env.deckService,
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
        let presenter: DeckDetailPresenter
        @ObservedObject var viewModel: DeckViewModel
        
        init(presenter: DeckDetailPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            VStack {
                Form {
                    FormLabelledField(label: "Name") {
                        TextField("Name", text: $viewModel.name)
                    }
                    
                    FormLabelledField(label: "Language") {
                        TextField("Language", text: $viewModel.language)
                    }
                    
                    if viewModel.id != nil {
                        Button("View Cards") {
                            presenter.viewCardsTapped()
                        }
                    }
                }
                
                if viewModel.hasCards {
                    Button("Practice") { presenter.practice() }
                        .buttonStyle(.borderedProminent)
                }

                Button("Save") { presenter.save() }
                    .buttonStyle(.borderedProminent)
                
                Button("Delete") { presenter.delete() }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
            }
            .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
}
