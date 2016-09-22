//
//  ViewState.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/16/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Foundation
import Messages

// Enumerates all possible configurations of MessagesView.
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

// Describes how to generate a ViewState from a Pair.
extension ViewState {
    init(pair: Pair?) {
        self = {
            switch pair {
            case .none: return .promptNew
            case .some(.translation(let translation)):
                if let q = translation.question, let a = translation.answer {
                    switch a {
                    case .unknown: return .translationCompleteUnknown(question: q)
                    case .known(let answer): return .translationCompleteKnown(question: q, answer: answer)
                    }
                } else if let q = translation.question {
                    return .translationPart(question: q)
                } else {
                    return .translationNew
                }
            case .some(.correction(let correction)):
                if let q = correction.question, let a = correction.answer {
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
        }()
    }
}
