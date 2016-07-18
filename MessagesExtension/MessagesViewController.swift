//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, MessagesViewDelegate {
    @IBOutlet weak var messagesView: MessagesView!
    
    // Along with `conversation`, `pair` is the only state retained through the lifetime
    // of MessagesViewController.
    var pair: Pair?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Conversation Handling
    
    // Essentially the entry point to our extension.
    //
    // `conversation` will either have an `selectedMessage` or nil.
    // An `selectedMessage` lets us know that the extension is being launched from an
    // existing message rather than the app keyboard browser being opened.
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)

        pair = Pair(conversation: conversation)
        let viewState = ViewState(pair: pair)
        messagesView.viewState = viewState
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        super.didBecomeActive(with: conversation)
    }
    override func didResignActive(with conversation: MSConversation) {
        super.didResignActive(with: conversation)
    }
    override func willResignActive(with conversation: MSConversation) {
        super.didResignActive(with: conversation)
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) { }
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) { }
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) { }
    
    // If our extension is already active and the user selects a message from this extension,
    // this method will be called instead of `willBecomeActive`.
    //
    // BUG: There seems to be be a bug in iOS 10 beta 1 where overridden
    // `willSelect` and `didSelect` are never called.
    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        super.willSelect(message, conversation: conversation)
        
        pair = Pair(conversation: conversation)
        let viewState = ViewState(pair: pair)
        messagesView.viewState = viewState
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
    }
    
    // Called when transitioning to/from the app keyboard browser and full screen.
    //
    // In this extension we only show the `promptNew` view in compact mode.
    //
    // You'll have to determine your own rules for how to handle user initiated transitions
    // via the disclosure button in the top/bottom right corner.
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        
        switch presentationStyle {
        case .compact:
            // Reset to .promptNew on collapse.
            let newPair: Pair? = nil
            let newViewState = ViewState(pair: newPair)
            self.pair = newPair
            self.messagesView.viewState = newViewState
        case .expanded:
            break
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
    }
    
    // MARK: MessagesViewDelegate
    
    // Essentially the exit point of our extension.
    //
    // The extension will either:
    // * Expand (if it isn't already) to capture a new translation or correction.
    // * Attach a new message to the conversation and dismiss.
    //
    // In both cases our model is updated by combining the view action with the previous model
    // and a new view state is generated from the updated model.
    func didAction(_ view: MessagesView, action: ViewAction, state: ViewState) {
        let newPair = action.combine(withPair: self.pair)
        let newViewState = ViewState(pair: newPair)
        
        switch newViewState {
        case .promptNew:
            break
        case .translationNew, .correctionNew:
            requestPresentationStyle(.expanded)
        default:
            guard let conversation = activeConversation else { fatalError("Expected a conversation") }
            let session = conversation.selectedMessage?.session ?? MSSession()
            guard let message = newPair.composeMessage(session) else { fatalError("Expected a message") }
            message.summaryText = state.changeDescription()
            conversation.insert(message) { error in
                if let error = error {
                    fatalError("Message could not be inserted into conversation: \(error)") // TODO: investigate when this happens
                }
            }
            dismiss()
        }
        
        self.pair = newPair
        self.messagesView.viewState = newViewState
    }
    
}

