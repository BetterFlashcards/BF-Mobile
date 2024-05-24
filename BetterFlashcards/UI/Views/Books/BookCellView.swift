//
//  BookCellView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct BookCellView: View {
    let book: Book
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
            Text(book.author)
                .font(.caption)
        }
    }
}
