//
//  BookListView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI
import GRDBQuery

struct BookListScreen: View {
    @EnvironmentStateObject var presenter: BookListPresenter
    
    init() {
        _presenter = EnvironmentStateObject { env in
            BookListPresenter(bookService: env.bookService)
        }
    }
    
    var body: some View {
        NavigationStack {
            ListView(presenter: presenter) { book in
                NavigationLink(to: .bookDetails(book)) {
                    BookCellView(book: book)
                }
            }
            .withDefaultRouter(viewModel: presenter.viewModel)
            .navigationTitle("Books")
        }
    }
}