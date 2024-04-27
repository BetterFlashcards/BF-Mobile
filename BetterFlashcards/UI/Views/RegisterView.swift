//
//  RegisterView.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct RegisterView: View {
    @Binding var username: String
    @Binding var password: String
    var onRegister: () -> Void
    var onLogin: () -> Void
    
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
            Button("Register", action: onRegister)
                .disabled(username.isEmpty || password.isEmpty)
                .buttonStyle(.borderedProminent)
            
            Button("Already have an account?", action: onLogin)
                .buttonStyle(.borderless)
            
        }.navigationTitle("Register")
    }
}
