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
    
    var pair: Pair?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        pair = Pair(conversation: conversation)
        let viewState = ViewState(pair: pair)
        messagesView.viewState = viewState
    }
    
    override func didResignActive(with conversation: MSConversation) { }
    override func didReceive(_ message: MSMessage, conversation: MSConversation) { }
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) { }
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) { }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
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
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) { }
    
    // MARK: MessagesViewDelegate
    
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
            let changeDescription = state.changeDescription()
            conversation.insert(message, localizedChangeDescription: changeDescription) { error in
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

