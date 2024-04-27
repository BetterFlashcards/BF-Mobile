//
//  FlashCardGridCell.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct FlashCardGridCell: View {
    let flashCard: FlashCard
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(flashCard.frontWord)
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }.aspectRatio(1, contentMode: .fill)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
}
