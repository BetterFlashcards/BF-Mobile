//
//  AuthView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI
import GRDBQuery

struct AuthView: View {
    @EnvironmentStateObject var presenter: AuthenticationPresenter
    
    init() {
        _presenter = EnvironmentStateObject { env in
            AuthenticationPresenter(authService: env.auth)
        }
    }
    
    var body: some View {
        NavigationStack {
            MainView(presenter: presenter)
                .withDefaultRouter(viewModel: presenter.viewModel)
                .task {
                    await presenter.setup()
                }
        }
    }
    
    private struct MainView: View {
        let presenter: AuthenticationPresenter
        @ObservedObject var viewModel: AuthenticationViewModel
        
        init(presenter: AuthenticationPresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            Group {
                switch viewModel.type {
                case .login:
                    LoginView(
                        username: $viewModel.username,
                        password: $viewModel.password,
                        onLogin: { Task { await presenter.login() } },
                        onRegister: { presenter.switchType() }
                    )
                case .register:
                    RegisterView(
                        username: $viewModel.username,
                        password: $viewModel.password,
                        onRegister: { Task { await presenter.register() } },
                        onLogin: { presenter.switchType() }
                    )
                }
            }
        }
    }
}
