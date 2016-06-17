//
//  ViewState.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/16/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Foundation
import Messages

enum ViewState {
    case promptNew
    case translationNew
    case translationPart(question: String)
    case translationCompleteUnknown(question: String)
    case translationCompleteKnown(question: String, answer: String)
    case correctionNew
    case correctionPart(question: String)
    case correctionCompleteIncorrect(question: String, answer: String)
    case correctionCompleteUnknown(question: String)
    case correctionCompleteCorrect(question: String)
}

extension ViewState {
    static func fromConversation(_ conversation: MSConversation) -> ViewState {
        guard let message = conversation.selectedMessage else { return .promptNew }
        guard let pair = Pair(message: message) else { return .promptNew }
        return fromPair(pair)
    }
    
    static func fromPair(_ pair: Pair) -> ViewState {
        switch pair {
        case (.translation(let translation)):
            if let q = translation.question, a = translation.answer {
                switch a {
                case .unknown: return .translationCompleteUnknown(question: q)
                case .known(let answer): return .translationCompleteKnown(question: q, answer: answer)
                }
            } else if let q = translation.question {
                return .translationPart(question: q)
            } else {
                return .translationNew
            }
        case (.correction(let correction)):
            if let q = correction.question, a = correction.answer {
                switch a {
                case .unknown: return .correctionCompleteUnknown(question: q)
                case .correct: return .correctionCompleteCorrect(question: q)
                case .incorrect(let answer): return .correctionCompleteIncorrect(question: q, answer: answer)
                }
            } else if let q = correction.question {
                return .correctionPart(question: q)
            } else {
                return .correctionNew
            }
        }
    }
}
