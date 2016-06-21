//
//  Messages.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

extension Pair {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}

extension Pair {
    init?(conversation: MSConversation) {
        guard let message = conversation.selectedMessage else { return nil }
        guard let pair = Pair(message: message) else { return nil }
        self = pair
    }
}

extension Pair {
    func composeMessage(_ session: MSSession) -> MSMessage? {
        var components = URLComponents()
        components.queryItems = self.queryItems
        
        let viewState = ViewState(pair: self)
        
        let layout = MSMessageTemplateLayout()
        if let message = viewState.messageTemplateLayout {
            layout.caption = message.caption
            layout.subcaption = message.subcaption
            layout.trailingCaption = message.trailingCaption
            layout.trailingSubcaption = message.trailingSubcaption
        } else {
            return nil
        }
        
        let message = MSMessage(session: session)
        message.url = components.url!
        message.layout = layout
        
        return message
    }
}

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

