//
//  TranslationLanguageQueries.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import APIClient

struct TranslationLanguageQueries: StringKeyValueConvertible {
    let source: Language
    let target: Language
    
    func keyValues() -> [KeyValuePair<String>] {
        [
            ("source_lang", source.isocode),
            ("target_lang", target.isocode)
            
        ]
    }
}
