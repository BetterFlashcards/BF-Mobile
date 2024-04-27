//
//  ListViewModelProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 21/04/2024.
//

import Foundation

@MainActor
protocol ListViewPresenterProtocol<Item> {
    associatedtype Item: Identifiable
    
    var viewModel: ListViewModel<Item> { get }
    
    func setup()
    func getFullList() async throws -> [Item]
    func getList(at: Int) async throws -> [Item]
    func delete(_: Item) async throws -> Item
    func didDisplay(_ item: Item)
}

extension ListViewPresenterProtocol {
    func didDisplay(_ item: Item) {
        if viewModel.hasNextPage && item.id == viewModel.list.last?.id {
            Task {
                await self.load(page: viewModel.currentPage + 1)
            }
        }
    }

    func firstLoad() async {
        setup()
        await loadAll()
    }
    
    func refresh() async {
        viewModel.list = []
        viewModel.currentPage = 0
        viewModel.hasNextPage = true
        await firstLoad()
    }
    
    func loadAll() async {
        do {
            viewModel.isLoading = true
            let items = try await getFullList()
            viewModel.hasNextPage = false
            viewModel.list.removeAll()
            viewModel.list.append(contentsOf: items)
            viewModel.currentPage = 0
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
        viewModel.isLoading = false
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
    
    func delete(at index: Int) async {
        let item = viewModel.list[index]
        do {
            _ = try await delete(item)
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
    }
}
