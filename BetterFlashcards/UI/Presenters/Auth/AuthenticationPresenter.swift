//
//  AuthenticationPresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

@MainActor
class AuthenticationPresenter: ObservableObject {
    @Published var viewModel: AuthenticationViewModel
    
    private let authService: AuthenticationServiceProtocol
    private var cancelSet: Set<AnyCancellable> = []
    
    init(authService: AuthenticationServiceProtocol) {
        self.viewModel = AuthenticationViewModel()
        self.authService = authService
    }
    
    func setup() async {
        authService.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }.store(in: &cancelSet)
        
    }
    
    func switchType() {
        viewModel.type.toggle()
        viewModel.password = ""
    }
    
    func login() async {
        do {
            _ = try await authService.login(
                username: viewModel.username,
                password: viewModel.password
            )
            viewModel.isLoggedIn = true
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    func register() async {
        do {
            _ = try await authService.register(
                username: viewModel.username,
                password: viewModel.password
            )
            viewModel.isLoggedIn = true
        } catch {
            viewModel.error = ViewError(error: error)
        }
    }
    
    private func handle(_ event: AuthenticationServiceEvent) {
        switch event {
        case .loggedOut:
            viewModel.fullScreen = nil
            viewModel.isLoggedIn = false
        case .loggedIn(let user), .registered(let user):
            viewModel.fullScreen = .homeScreen
            viewModel.isLoggedIn = true
            viewModel.username = user.username
        }
    }
}
