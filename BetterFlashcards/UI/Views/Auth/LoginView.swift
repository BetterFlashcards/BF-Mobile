//
//  LoginView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    var onLogin: () -> Void
    var onRegister: () -> Void
    
    var body: some View {
        VStack {
            Form {
                FormLabelledField(label: "Username") {
                    TextField("Username", text: $username)
                }
                
                FormLabelledField(label: "Password") {
                    SecureField("Password", text: $password)
                }
            }

            Button("Login", action: onLogin)
                .disabled(username.isEmpty || password.isEmpty)
                .buttonStyle(.borderedProminent)
            
            Button("Don't have an account?", action: onRegister)
                .buttonStyle(.borderless)
            
        }.navigationTitle("Login")
    }
}
