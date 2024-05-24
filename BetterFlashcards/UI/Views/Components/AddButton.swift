//
//  AddButton.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Add", systemImage: "plus")
        }.labelStyle(.iconOnly)
    }
}
