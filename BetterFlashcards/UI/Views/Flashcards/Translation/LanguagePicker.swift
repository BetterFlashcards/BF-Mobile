//
//  LanguagePicker.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import SwiftUI
import GRDBQuery

struct LanguagePicker: View {
    @EnvironmentStateObject var presenter: LanguagePickerPresenter
    
    init(onSelect: @escaping (Language) -> Void) {
        self._presenter = EnvironmentStateObject { env in
            LanguagePickerPresenter(
                languageService: env.languageService,
                onSelect: onSelect,
                dismiss: env.dismiss
            )
        }
    }
    
    var body: some View {
        ListView(presenter: presenter) { language in
            VStack(alignment: .leading) {
                Text(language.name)
                Text(language.isocode)
                    .font(.caption)
            }.onTapGesture {
                presenter.select(language: language)
            }
        }.task { await presenter.firstLoad() }
    }
}
