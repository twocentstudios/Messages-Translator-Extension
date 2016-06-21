//
//  ViewAction.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

// Enumerates all the possible user actions returned by MessagesView.
enum ViewAction {   
    case createNewTranslation
    case createNewCorrection
    case addTranslation(question: String)
    case completeTranslationKnown(answer: String)
    case completeTranslationUnknown
    case addCorrection(question: String)
    case completeCorrectionIncorrect(answer: String)
    case completeCorrectionCorrect
    case completeCorrectionUnknown
}

// Describes how to generate a new model from any previous model and a ViewAction.
extension ViewAction {
    func combine(withPair pair: Pair?) -> Pair {
        switch (self, pair) {
        case (.createNewCorrection, _):
            return .correction(self.combine(withCorrection: Correction()))
        case (.createNewTranslation, _):
            return .translation(self.combine(withTranslation: Translation()))
        case (_, .some(.correction(let correction))):
            return .correction(self.combine(withCorrection: correction))
        case (_, .some(.translation(let translation))):
            return .translation(self.combine(withTranslation: translation))
        default: fatalError("Invalid ViewAction/Pair combination.")
        }
    }
    
    func combine(withCorrection correction: Correction) -> Correction {
        var correction = correction
        switch self {
        case .addCorrection(let question):
            correction.question = question
        case .completeCorrectionCorrect:
            correction.answer = CorrectionAnswer.correct
        case .completeCorrectionUnknown:
            correction.answer = CorrectionAnswer.unknown
        case .completeCorrectionIncorrect(let answer):
            correction.answer = CorrectionAnswer.incorrect(answer)
        default: break
        }
        return correction
    }
    
    func combine(withTranslation translation: Translation) -> Translation {
        var translation = translation
        switch self {
        case .addTranslation(let question):
            translation.question = question
        case .completeTranslationUnknown:
            translation.answer = TranslationAnswer.unknown
        case .completeTranslationKnown(let answer):
            translation.answer = TranslationAnswer.known(answer)
        default: break
        }
        return translation
    }
}
