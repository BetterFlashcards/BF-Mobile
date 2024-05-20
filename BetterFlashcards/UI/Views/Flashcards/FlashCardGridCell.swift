//
//  FlashCardGridCell.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import SwiftUI

struct FlashCardGridCell: View {
    let flashCard: FlashCard
    @Binding var flipped: Bool
    
    @State private var degrees: Double
    @State private var textDegrees: Double
    @State private var shownText: String
    
    init(flashCard: FlashCard, flipped: Binding<Bool> = .constant(false)) {
        self.flashCard = flashCard
        self.shownText = flashCard.frontWord
        self.degrees = 0
        self.textDegrees = 0
        self._flipped = flipped
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(shownText)
                    .rotation3DEffect(.degrees(textDegrees), axis: (x: 0, y: 1, z: 0))
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }.aspectRatio(1, contentMode: .fill)
        .background(Color.blue)
        .shadow(color: .gray, radius: 10)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
        .onChange(of: flipped) { flipped in
            withAnimation {
                self.degrees = flipped ? 180 : 0
                self.shownText = flipped ? flashCard.backWord : flashCard.frontWord
                self.textDegrees = flipped ? -180 : 0
            }
            
        }
    }
}
