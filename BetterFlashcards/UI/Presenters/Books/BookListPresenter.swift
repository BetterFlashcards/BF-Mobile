//
//  BookListViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

@MainActor
class BookListPresenter: PaginatedListViewPresenterProtocol, ObservableObject {
    @Published var viewModel = ListViewModel<Book>()
    let pageSize = 20
    
    private let bookService: any BookServiceProtocol
    private var cancelSet: Set<AnyCancellable> = []
    
    init(bookService: any BookServiceProtocol) {
        self.bookService = bookService
    }
    
    func setup() {
        bookService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
    }

    func getPaginatedList(at pagination: Pagination) async throws -> PaginatedList<Book> {
        try await bookService.getList(at: pagination)
    }
 
    func delete(_ book: Book) async throws -> Book {
        try await bookService.delete(book)
    }
    
    func addTapped() {
        viewModel.sheet = .bookCreation
    }
    
    private func handle(_ event: BookServiceEvent) {
        switch event {
        case .added(_):
            Task { await self.refresh() }
        case .updated(let book):
            viewModel.list[id: book.id] = book
        case .deleted(let book):
            viewModel.list.remove(id: book.id)
        }
    }
}
