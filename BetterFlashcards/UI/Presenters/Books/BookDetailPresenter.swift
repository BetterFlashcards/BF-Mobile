//
//  BookDetailPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BookDetailPresenter: ObservableObject {
    @Published var viewModel: BookViewModel

    private let bookService: any BookServiceProtocol
    private let dismiss: DismissAction
    private var cancelSet: Set<AnyCancellable> = []
    
    init(
        book: Book? = nil,
        bookService: any BookServiceProtocol,
        dismiss: DismissAction
    ) {
        if let book {
            self.viewModel = BookViewModel(
                id: book.id,
                title: book.title,
                author: book.author,
                fileURL: bookService.existingURL(for: book)
            )
        } else {
            self.viewModel = BookViewModel()
        }
        
        self.bookService = bookService
        self.dismiss = dismiss
    }
    
    func setup() async {
        bookService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }
    
    func save() {
        let book = viewModel.toBook()
        let id = viewModel.id
        Task {
            if id != nil {
                await update(book: book)
            } else {
                await create(book: book)
                dismiss()
            }
        }
    }
    
    func create(book: Book) async {
        do {
            viewModel.isLoading = true
            let book = try await bookService.create(book)
            viewModel.id = book.id
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func update(book: Book) async {
        do {
            viewModel.isLoading = true
            _ = try await bookService.update(book)
            viewModel.isLoading = false
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func delete() {
        guard viewModel.id != nil else { return }
        let book = viewModel.toBook()
        Task {
            do {
                _ = try await bookService.delete(book)
            } catch {
                viewModel.error = ViewError(error: error)
            }
        }
    }
    
    func importTapped() {
        viewModel.isImporting = true
    }
    
    func handleImport(result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            viewModel.error = ViewError(error: error)
        case .success(let url):
            Task {
                let url = try await bookService.importFile(at: url, for: viewModel.toBook())
                viewModel.fileURL = url
            }
        }
    }
    
    func read(url: URL) {
        viewModel.openingURL = url
    }
    
    func handle(_ event: BookServiceEvent) {
        switch event {
        case .updated(let book) where book.id == self.viewModel.id:
            viewModel.title = book.title
            viewModel.author = book.author
        case .deleted(let card) where card.id == self.viewModel.id:
            dismiss()
        default:
            break
        }
    }
}
