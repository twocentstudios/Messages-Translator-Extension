//
//  Messages.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

// Create a Pair from an MSMessage.
extension Pair {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}

// Create a Pair from an MSConversation.
extension Pair {
    init?(conversation: MSConversation) {
        guard let message = conversation.selectedMessage else { return nil }
        guard let pair = Pair(message: message) else { return nil }
        self = pair
    }
}

// Create an MSMessage from a Pair.
extension Pair {
    func composeMessage(_ session: MSSession) -> MSMessage? {
        var components = URLComponents()
        components.queryItems = self.queryItems
        
        let viewState = ViewState(pair: self)
        
        guard let messageLayout = viewState.messageTemplateLayout else { return nil }
        guard let accessibilityLabel = viewState.accessibilityLabel else { return nil }

        let layout = MSMessageTemplateLayout()
        layout.caption = messageLayout.caption
        layout.subcaption = messageLayout.subcaption
        layout.trailingCaption = messageLayout.trailingCaption
        layout.trailingSubcaption = messageLayout.trailingSubcaption
        
        let message = MSMessage(session: session)
        message.url = components.url!
        message.layout = layout
        message.accessibilityLabel = accessibilityLabel
        
        return message
    }
}

// Create a textual description of a ViewState used by MSMessage.
extension ViewState {
    func changeDescription() -> String? {
        switch self {
        case .promptNew, .translationNew, .correctionNew:
            // Introductory states.
            return nil
        case .translationCompleteUnknown, .translationCompleteKnown, .correctionCompleteCorrect, .correctionCompleteUnknown, .correctionCompleteIncorrect:
            // Ending states.
            return nil
        case .translationPart:
            return NSLocalizedString("A new translation request was created.", comment: "")
        case .correctionPart:
            return NSLocalizedString("A new correction request was created.", comment: "")
        }
    }
}

// Create a textual description of a ViewState used by MSMessage.
extension ViewState {
    var accessibilityLabel: String? {
        switch self {
        case .promptNew, .translationNew, .correctionNew:
            // Introductory states.
            return nil
        case .translationPart(let question):
            return NSLocalizedString("Translation request. \(question)", comment: "")
        case .correctionPart(let question):
            return NSLocalizedString("Correction request. \(question)", comment: "")
        case .translationCompleteUnknown(let question):
            return NSLocalizedString("Translation request. \(question). Answer is unknown.", comment: "")
        case .translationCompleteKnown(let question, let answer):
            return NSLocalizedString("Translation request. \(question). Answer is \(answer)", comment: "")
        case .correctionCompleteCorrect(let question):
            return NSLocalizedString("Correction request. \(question). Request is correct.", comment: "")
        case .correctionCompleteUnknown(let question):
            return NSLocalizedString("Correction request. \(question). Answer is unknown.", comment: "")
        case .correctionCompleteIncorrect(let question, let answer):
            return NSLocalizedString("Correction request. \(question). Answer is \(answer)", comment: "")

        }
    }
}


