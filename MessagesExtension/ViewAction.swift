//
//  ViewAction.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

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

extension ViewAction {
    func to(_ pair: Pair?) -> Pair? {
        switch (self, pair) {
        case (.createNewCorrection, _):
            return nil
        case (.createNewTranslation, _):
            return nil
        case (.addCorrection, _):
            return .correction(Correction().from(self))
        case (.addTranslation, _):
            return .translation(Translation().from(self))
        case (_, .some(.correction(let correction))):
            return .correction(correction.from(self))
        case (_, .some(.translation(let translation))):
            return .translation(translation.from(self))
        default:
            return nil
        }
    }
}

extension Pair {
    func from(_ viewAction: ViewAction) -> Pair {
        var pair = self
        switch self {
        case .correction(var correction):
            correction = correction.from(viewAction)
            pair = .correction(correction)
        case .translation(var translation):
            translation = translation.from(viewAction)
            pair = .translation(translation)
        }
        return pair
    }
}

extension Correction {
    func from(_ viewAction: ViewAction) -> Correction {
        var correction = self
        switch viewAction {
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
}

extension Translation {
    func from(_ viewAction: ViewAction) -> Translation {
        var translation = self
        switch viewAction {
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
