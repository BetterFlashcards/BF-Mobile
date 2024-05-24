//
//  TranslationPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import Foundation
import SwiftUI

class LanguagePickerPresenter: PaginatedListViewPresenterProtocol, ObservableObject {
    let pageSize = 20
    
    @Published var viewModel = ListViewModel<Language>()
    
    private let languageService: any LanguageServiceProtocol
    private let onSelect: (Language) -> Void
    private let dismiss: DismissAction
    
    init(
        languageService: any LanguageServiceProtocol,
        onSelect: @escaping (Language) -> Void,
        dismiss: DismissAction
    ) {
        self.languageService = languageService
        self.onSelect = onSelect
        self.dismiss = dismiss
    }
    
    func select(language: Language) {
        onSelect(language)
        dismiss()
    }
    
    func getPaginatedList(at pagination: Pagination) async throws -> PaginatedList<Language> {
        try await languageService.getList(at: pagination)
    }
    
    func setup() {
        
    }
    
    func delete(_ language: Language) async throws -> Language {
        return language
    }
}


@MainActor
class TranslationPresenter: ObservableObject {
    @Published var viewModel: TranslationViewModel
    
    private let languageService: any LanguageServiceProtocol
    private let onSelect: (Translation) -> Void
    private let dismiss: DismissAction
    
    init(
        word: String,
        languageService: any LanguageServiceProtocol,
        onSelect: @escaping (Translation) -> Void,
        dismiss: DismissAction
    ) {
        self.viewModel = TranslationViewModel(word: word)
        self.languageService = languageService
        self.onSelect = onSelect
        self.dismiss = dismiss
    }
    
    func select(translation: Translation) {
        onSelect(translation)
        dismiss()
    }
    
    func translate() {
        guard let source = viewModel.source, let target = viewModel.target else { return }
        Task {
            viewModel.isLoading = true
            viewModel.translations = try await languageService.translate(
                word: viewModel.word,
                from: source,
                to: target
            )
            viewModel.isLoading = false
        }
    }
    
    func changeSource(to source: Language) {
        viewModel.source = source
    }
    
    func changeTarget(to target: Language) {
        viewModel.target = target
    }
    
}
