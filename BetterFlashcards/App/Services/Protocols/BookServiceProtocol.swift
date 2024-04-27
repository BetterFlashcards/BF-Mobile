//
//  BookServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol BookServiceProtocol: GenericBasicServiceProtocol where Item == Book, Event == BookServiceEvent {
    
}

enum BookServiceEvent {
    case added(Book)
    case updated(Book)
    case deleted(Book)
}
