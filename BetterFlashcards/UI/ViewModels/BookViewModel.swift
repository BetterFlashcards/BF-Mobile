//
//  BookViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import Foundation

class BookViewModel: BaseViewModel {
    @Published var id: Book.ID?
    @Published var title: String
    @Published var author: String
    
    @Published var fileURL: URL?
    @Published var isImporting = false
    
    @Published var isLoading = false
    
    init(id: Book.ID? = nil, title: String = "", author: String = "", fileURL: URL? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.fileURL = fileURL
        super.init()
    }
    
    func toBook() -> Book {
        Book(id: id ?? -1, title: title, author: author)
    }
}
