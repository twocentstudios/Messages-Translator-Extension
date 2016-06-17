//
//  Translation.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

enum TranslationAnswer: RawRepresentable {
    case known(String)
    case unknown
    
    init?(rawValue: String) {
        switch rawValue {
        case "":
            self = .unknown
        case let rawValue:
            self = .known(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .unknown:
            return ""
        case .known(let known):
            return known
        }
    }
}

struct Translation {
    var question: String?
    var answer: TranslationAnswer?
    
    var isComplete: Bool {
        return question != nil && answer != nil
    }
}

extension TranslationAnswer: Equatable {}
func ==(lhs: TranslationAnswer, rhs: TranslationAnswer) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case let (.known(lKnown), .known(rKnown)):
        return lKnown == rKnown
    default:
        return false
    }
}

extension Translation: Equatable {}
func ==(lhs: Translation, rhs: Translation) -> Bool {
    return lhs.question == rhs.question && lhs.answer == rhs.answer
}
