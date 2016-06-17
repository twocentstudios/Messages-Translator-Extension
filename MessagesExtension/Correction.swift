//
//  Correction.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

enum CorrectionAnswer: RawRepresentable {
    case correct
    case incorrect(String)
    case unknown
    
    init?(rawValue: String) {
        switch rawValue {
        case "":
            self = .unknown
        case "✓":
            self = .correct
        case let rawValue:
            self = .incorrect(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .correct:
            return "✓"
        case .incorrect(let incorrect):
            return incorrect
        case .unknown:
            return ""
        }
    }
}

struct Correction {
    var question: String?
    var answer: CorrectionAnswer?
    
    var isComplete: Bool {
        return question != nil && answer != nil
    }
}

extension CorrectionAnswer: Equatable {}
func ==(lhs: CorrectionAnswer, rhs: CorrectionAnswer) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case (.correct, .correct):
        return true
    case let (.incorrect(lIncorrect), .incorrect(rIncorrect)):
        return lIncorrect == (rIncorrect)
    default:
        return false
    }
}

extension Correction: Equatable {}
func ==(lhs: Correction, rhs: Correction) -> Bool {
    return lhs.question == rhs.question && lhs.answer == rhs.answer
}
