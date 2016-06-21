//
//  MessagesView.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/16/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import UIKit

protocol MessagesViewDelegate: NSObjectProtocol {
    func didAction(_ view: MessagesView, action: ViewAction, state: ViewState)
}

class MessagesView: UIView {
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var translationButton: UIButton!
    @IBOutlet weak var correctionButton: UIButton!
    @IBOutlet weak var primaryAccept: UIButton!
    @IBOutlet weak var secondaryAccept: UIButton!
    @IBOutlet weak var ternaryAccept: UIButton!
    
    internal weak var delegate: MessagesViewDelegate?
    internal var viewState: ViewState {
        didSet {
            switch viewState {
            case .promptNew:
                textFieldStackView.isHidden = true
                buttonsStackView.isHidden = false
                questionTextField.text = nil
                answerTextField.text = nil
                translationButton.setTitle(NSLocalizedString("Ask for translation", comment: ""), for: [])
                correctionButton.setTitle(NSLocalizedString("Ask for correction", comment: ""), for: [])
                questionLabel.text = nil
                answerLabel.text = nil
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
            case .translationNew:
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = nil
                answerTextField.text = nil
                questionLabel.text = NSLocalizedString("Write in your native language:", comment: "")
                answerLabel.text = nil
                questionLabel.isHidden = false
                answerLabel.isHidden = true
                questionTextField.isEnabled = true
                answerTextField.isEnabled = false
                primaryAccept.setTitle(NSLocalizedString("Request Translation", comment: ""), for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = false
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case let .translationPart(question: q):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = nil
                questionLabel.text = NSLocalizedString("Please translate:", comment: "")
                answerLabel.text = NSLocalizedString("Your translation:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = true
                primaryAccept.setTitle(NSLocalizedString("Create Translation", comment: ""), for: [])
                secondaryAccept.setTitle(NSLocalizedString("Can't Translate", comment: ""), for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = false
                secondaryAccept.isHidden = false
                ternaryAccept.isHidden = true
            case let .translationCompleteUnknown(question: q):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = NSLocalizedString("Don't know", comment: "") // TODO: other UI
                questionLabel.text = NSLocalizedString("Native language:", comment: "")
                answerLabel.text = NSLocalizedString("Translated:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
                primaryAccept.setTitle(nil, for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = true
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case let .translationCompleteKnown(question: q, answer: a):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = a
                questionLabel.text = NSLocalizedString("Native language:", comment: "")
                answerLabel.text = NSLocalizedString("Translated:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
                primaryAccept.setTitle(nil, for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = true
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case .correctionNew:
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = nil
                answerTextField.text = nil
                questionLabel.text = NSLocalizedString("Write in your target language:", comment: "")
                answerLabel.text = nil
                questionLabel.isHidden = false
                answerLabel.isHidden = true
                questionTextField.isEnabled = true
                answerTextField.isEnabled = false
                primaryAccept.setTitle(NSLocalizedString("Request Correction", comment: ""), for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = false
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case let .correctionPart(question: q):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = nil
                questionLabel.text = NSLocalizedString("Please correct:", comment: "")
                answerLabel.text = NSLocalizedString("Your correction:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = true
                primaryAccept.setTitle(NSLocalizedString("Create Correction", comment: ""), for: [])
                secondaryAccept.setTitle(NSLocalizedString("Can't Correct", comment: ""), for: [])
                ternaryAccept.setTitle(NSLocalizedString("It's Correct!", comment: ""), for: [])
                primaryAccept.isHidden = false
                secondaryAccept.isHidden = false
                ternaryAccept.isHidden = false
            case let .correctionCompleteCorrect(question: q):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = NSLocalizedString("Correct!", comment: "") // TODO: other UI
                questionLabel.text = NSLocalizedString("Target language:", comment: "")
                answerLabel.text = NSLocalizedString("Corrected:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
                primaryAccept.setTitle(nil, for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = true
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case let .correctionCompleteUnknown(question: q):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = NSLocalizedString("Don't know", comment: "") // TODO: other UI
                questionLabel.text = NSLocalizedString("Target language:", comment: "")
                answerLabel.text = NSLocalizedString("Corrected:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
                primaryAccept.setTitle(nil, for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = true
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            case let .correctionCompleteIncorrect(question: q, answer: a):
                textFieldStackView.isHidden = false
                buttonsStackView.isHidden = true
                questionTextField.text = q
                answerTextField.text = a
                questionLabel.text = NSLocalizedString("Target language:", comment: "")
                answerLabel.text = NSLocalizedString("Corrected:", comment: "")
                questionLabel.isHidden = false
                answerLabel.isHidden = false
                questionTextField.isEnabled = false
                answerTextField.isEnabled = false
                primaryAccept.setTitle(nil, for: [])
                secondaryAccept.setTitle(nil, for: [])
                ternaryAccept.setTitle(nil, for: [])
                primaryAccept.isHidden = true
                secondaryAccept.isHidden = true
                ternaryAccept.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        viewState = ViewState.promptNew
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewState = ViewState.promptNew
        super.init(coder: aDecoder)
    }

    @IBAction func translationButtonTap(_ sender: UIButton) {
        delegate?.didAction(self, action: ViewAction.createNewTranslation, state: viewState)
    }
    
    @IBAction func correctionButtonTap(_ sender: UIButton) {
        delegate?.didAction(self, action: ViewAction.createNewCorrection, state: viewState)
    }
    
    @IBAction func primaryAcceptTap(_ sender: UIButton) {
        var viewAction: ViewAction?
        switch viewState {
        case .translationNew:
            if let text = questionTextField.text where !text.isEmpty {
                viewAction = ViewAction.addTranslation(question: text)
            }
        case .translationPart:
            if let text = answerTextField.text where !text.isEmpty {
                viewAction = ViewAction.completeTranslationKnown(answer: text)
            }
        case .correctionNew:
            if let text = questionTextField.text where !text.isEmpty {
                viewAction = ViewAction.addCorrection(question: text)
            }
        case .correctionPart:
            if let text = answerTextField.text where !text.isEmpty {
                viewAction = ViewAction.completeCorrectionIncorrect(answer: text)
            }
        default: break
        }
        
        if let viewAction = viewAction {
            delegate?.didAction(self, action: viewAction, state: viewState)
        }
    }
   
    @IBAction func secondaryAcceptTap(_ sender: UIButton) {
        var viewAction: ViewAction?
        switch viewState {
        case .translationPart:
            viewAction = ViewAction.completeTranslationUnknown
        case .correctionPart:
            viewAction = ViewAction.completeCorrectionUnknown
        default: break
        }
        
        if let viewAction = viewAction {
            delegate?.didAction(self, action: viewAction, state: viewState)
        }
    }
    
    @IBAction func ternaryAcceptTap(_ sender: UIButton) {
        var viewAction: ViewAction?
        switch viewState {
        case .correctionPart:
            viewAction = ViewAction.completeCorrectionCorrect
        default: break
        }
        
        if let viewAction = viewAction {
            delegate?.didAction(self, action: viewAction, state: viewState)
        }
    }
}
