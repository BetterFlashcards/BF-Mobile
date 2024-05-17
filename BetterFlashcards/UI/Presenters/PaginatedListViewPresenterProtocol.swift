//
//  PaginatedListViewPresenterProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

@MainActor
protocol PaginatedListViewPresenterProtocol<Item>: ListViewPresenterProtocol {
    var pageSize: Int { get }
    func getPaginatedList(at: Pagination) async throws -> PaginatedList<Item>
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
            let pagination = Pagination(page: page, size: self.pageSize)
            let result = try await getPaginatedList(at: pagination)
            viewModel.list.append(contentsOf: result.items)
            viewModel.currentPage = result.pagination.page
            viewModel.hasNextPage = result.hasNextPage
        } catch {
            viewModel.error = ViewError(error: error)
        }
        viewModel.isLoading = false
    }
}
