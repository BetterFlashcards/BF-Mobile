//
//  PaginatedListViewPresenterProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

@MainActor
protocol PaginatedListViewPresenterProtocol<Item>: ListViewPresenterProtocol {
    func getList(at: Int) async throws -> [Item]
    func didDisplay(_ item: Item)
}

extension PaginatedListViewPresenterProtocol {
    func firstLoad() async {
        setup()
        await load(page: 0)
    }
    
    func didDisplay(_ item: Item) {
        if viewModel.hasNextPage && item.id == viewModel.list.last?.id {
            Task {
                await self.load(page: viewModel.currentPage + 1)
            }
        }
    }
    
    func load(page: Int) async {
        do {
            viewModel.isLoading = true
            let items = try await getList(at: page)
            if items.isEmpty {
                viewModel.hasNextPage = false
            } else {
                viewModel.list.append(contentsOf: items)
            }
            viewModel.currentPage = page
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
        viewModel.isLoading = false
    }
}
