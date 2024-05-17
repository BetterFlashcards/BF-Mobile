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
    func firstLoad() async
    func getFullList() async throws -> [Item]
    func delete(_: Item) async throws -> Item
}

extension ListViewPresenterProtocol {
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
            viewModel.error = ViewError(error: error)
        }
        viewModel.isLoading = false
    }
    
    func delete(at index: Int) async {
        let item = viewModel.list[index]
        do {
            _ = try await delete(item)
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
}
