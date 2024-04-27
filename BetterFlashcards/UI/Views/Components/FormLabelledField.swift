//
//  FormLabelledField.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct FormLabelledField<Field: View>: View {
    let label: String
    @ViewBuilder let fieldBuilder: () -> Field
    
    var body: some View {
        HStack {
            Text(label)
            fieldBuilder()
                .multilineTextAlignment(.trailing)
        }
    }
}
