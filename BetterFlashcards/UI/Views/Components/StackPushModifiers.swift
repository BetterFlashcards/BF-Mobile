//
//  StackPushModifiers.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import SwiftUI

extension View {
    func pushCenterHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    func pushCenterVertically() -> some View {
        VStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    func pushBottom() -> some View {
        VStack {
            Spacer()
            self
        }
    }
}

