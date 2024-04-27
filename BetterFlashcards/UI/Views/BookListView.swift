//
//  BookListView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI
import GRDBQuery

struct BookListView: View {
    @EnvironmentStateObject var presenter: BookListPresenter
    
    init() {
        _presenter = EnvironmentStateObject { env in
            BookListPresenter(bookService: env.bookService)
        }
    }
    
    var body: some View {
        ListView(presenter: presenter) { book in
            BookCellView(book: book)
        }
        .navigationTitle("Books")
    }
}
