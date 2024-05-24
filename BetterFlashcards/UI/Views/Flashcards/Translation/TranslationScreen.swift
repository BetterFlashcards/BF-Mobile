//
//  TranslationScreen.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import SwiftUI
import GRDBQuery

struct TranslationScreen: View {
    @EnvironmentStateObject var presenter: TranslationPresenter
    
    init(word: String, onSelect: @escaping (Translation) -> Void) {
        _presenter = EnvironmentStateObject { env in
            TranslationPresenter(
                word: word,
                languageService: env.languageService,
                onSelect: onSelect,
                dismiss: env.dismiss
            )
        }
    }
    
    var body: some View {
        MainView(presenter: presenter)
    }
    
    struct MainView: View {
        let presenter: TranslationPresenter
        @ObservedObject var viewModel: TranslationViewModel
        
        init(presenter: TranslationPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            VStack {
                Form {
                    Section(header: Text("Options")) {
                        FormLabelledField(label: "Word") {
                            Text(viewModel.word)
                        }
                        
                        NavigationLink(to: .languagePicker(onSelect: { presenter.changeSource(to: $0) })) {
                            HStack {
                                Text("Source Language")
                                Spacer()
                                Text(viewModel.source?.name ?? "Select")
                            }
                        }
                        
                        NavigationLink(to: .languagePicker(onSelect: { presenter.changeTarget(to: $0) })) {
                            HStack {
                                Text("Target Language")
                                Spacer()
                                Text(viewModel.target?.name ?? "Select")
                            }
                        }
                    }
                    
                    if let translations = viewModel.translations {
                        Section(header: Text("Translations")) {
                            ForEach(translations) { translation in
                                Text(translation.translation)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        presenter.select(translation: translation)
                                    }
                            }
                        }
                    } else if viewModel.isLoading {
                        ProgressView()
                            .pushCenterHorizontally()
                    }
                }
                
                if viewModel.source != nil && viewModel.target != nil {
                    Button("Translate") { presenter.translate() }
                        .buttonStyle(.borderedProminent)
                }
            }.navigationBarTitle("Translate")
            .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
}
