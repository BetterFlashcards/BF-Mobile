//
//  ListView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 21/04/2024.
//

import SwiftUI

struct ListView<Presenter: PaginatedListViewPresenterProtocol, Cell>: View where Cell: View {
    typealias Item = Presenter.Item
    let presenter: Presenter
    @ObservedObject var viewModel: ListViewModel<Item>
    let cellBuilder: (Item) -> Cell
    
    @MainActor
    init(presenter: Presenter, cellBuilder: @escaping (Item) -> Cell) {
        self.presenter = presenter
        self.viewModel = presenter.viewModel
        self.cellBuilder = cellBuilder
    }
    
    var body: some View {
        List {
            ForEach(viewModel.list) { item in
                cellBuilder(item)
                    .onAppear {
                        presenter.didDisplay(item)
                    }
            }.onDelete { indexSet in
                guard let index = indexSet.first else { return }
                Task {
                    await presenter.delete(at: index)
                }
            }
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            }
        }
        .refreshable { await presenter.refresh() }
        .task { await presenter.firstLoad() }
    }
}
