//
//  HomePresenter.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 09/05/2024.
//

import Foundation

@MainActor
class HomePresenter: ObservableObject {
    let auth: AuthenticationServiceProtocol
    @Published var viewModel = BaseViewModel()
    
    init(auth: AuthenticationServiceProtocol) {
        self.auth = auth
    }
    
    func logout() {
        Task {
            await auth.logout()
        }
    }
}
