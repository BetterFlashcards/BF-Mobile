//
//  BookDetailScreen.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import SwiftUI
import GRDBQuery

struct BookDetailScreen: View {
    @EnvironmentStateObject var presenter: BookDetailPresenter
    
    init(book: Book? = nil) {
        _presenter = EnvironmentStateObject { env in
            BookDetailPresenter(
                book: book,
                bookService: env.bookService,
                dismiss: env.dismiss
            )
        }
    }
    
    var body: some View {
        MainView(presenter: presenter)
            .task { await presenter.setup() }
    }
    
    private struct MainView: View {
        let presenter: BookDetailPresenter
        @ObservedObject var viewModel: BookViewModel
        
        init(presenter: BookDetailPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            VStack {
                Form {
                    FormLabelledField(label: "Title") {
                        TextField("Title", text: $viewModel.title)
                    }
                    
                    FormLabelledField(label: "Author") {
                        TextField("Author", text: $viewModel.author)
                    }
                }

                if viewModel.id != nil {
                    if let url = viewModel.fileURL {
                        Button("Read") { presenter.read(url: url) }
                    } else {
                        Button("Import") { presenter.importTapped() }
                    }
                }
                
                Button("Save") { presenter.save() }
                
                Button("Delete") { presenter.delete() }
                    .tint(.red)
            }.fileImporter(
                isPresented: $viewModel.isImporting,
                allowedContentTypes: [.pdf],
                onCompletion: { presenter.handleImport(result: $0) }
            )
            .withDefaultRouter(viewModel: presenter.viewModel)
            .buttonStyle(.borderedProminent)
        }
    }
}

