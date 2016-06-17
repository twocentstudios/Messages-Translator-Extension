//
//  MessageLayoutTemplate.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Foundation

struct MessageTemplateLayout {
    var caption: String?
    var subcaption: String?
    var trailingCaption: String?
    var trailingSubcaption: String?
}

extension ViewState {
    var messageTemplateLayout: MessageTemplateLayout? {
        switch self {
        case .promptNew:
            return nil
        case .translationNew:
            return nil
        case let .translationPart(question: q):
            return MessageTemplateLayout(
                caption: q,
                subcaption: NSLocalizedString("Tap to add your translation.", comment: ""),
                trailingCaption: nil,
                trailingSubcaption: nil)
        case let .translationCompleteUnknown(question: q):
            return MessageTemplateLayout(
                caption: q,
                subcaption: nil,
                trailingCaption: nil,
                trailingSubcaption: NSLocalizedString("Translation is unknown.", comment: ""))
        case let .translationCompleteKnown(question: q, answer: a):
            return MessageTemplateLayout(
                caption: q,
                subcaption: a,
                trailingCaption: nil,
                trailingSubcaption: nil)
        case .correctionNew:
            return nil
        case let .correctionPart(question: q):
            return MessageTemplateLayout(
                caption: q,
                subcaption: NSLocalizedString("Tap to add your correction.", comment: ""),
                trailingCaption: nil,
                trailingSubcaption: nil)
        case let .correctionCompleteCorrect(question: q):
            return MessageTemplateLayout(
                caption: q,
                subcaption: nil,
                trailingCaption: nil,
                trailingSubcaption: NSLocalizedString("Correct!", comment: ""))
        case let .correctionCompleteUnknown(question: q):
            return MessageTemplateLayout(
                caption: q,
                subcaption: nil,
                trailingCaption: nil,
                trailingSubcaption: NSLocalizedString("Not sure how to correct this.", comment: ""))
        case let .correctionCompleteIncorrect(question: q, answer: a):
            return MessageTemplateLayout(
                caption: q,
                subcaption: a,
                trailingCaption: nil,
                trailingSubcaption: nil)
        }
    }
}
