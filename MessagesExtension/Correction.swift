//
//  Correction.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

enum CorrectionAnswer: RawRepresentable {
    case correct
    case incorrect(String)
    case unknown
    
    init?(rawValue: String) {
        switch rawValue {
        case "":
            self = .unknown
        case "✓":
            self = .correct
        case let rawValue:
            self = .incorrect(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .correct:
            return "✓"
        case .incorrect(let incorrect):
            return incorrect
        case .unknown:
            return ""
        }
    }
}

struct Correction {
    var question: String?
    var answer: CorrectionAnswer?
    
    var isComplete: Bool {
        return question != nil && answer != nil
    }
}



extension Correction {
    static let questionQueryName = "question"
    static let answerQueryName = "answer"
    
    var questionQueryItem: URLQueryItem? {
        guard let question = question else { return nil }
        return URLQueryItem(name: Translation.questionQueryName, value: question)
    }
    
    var answerQueryItem: URLQueryItem? {
        guard let answer = answer else { return nil }
        return URLQueryItem(name: Translation.answerQueryName, value: answer.rawValue)
    }
}

/**
 Extends `Correction` to be able to be represented by and created with an array of
 `NSURLQueryItem`s.
 */
extension Correction {
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        if let item = questionQueryItem {
            items.append(item)
        }
        if let item = answerQueryItem {
            items.append(item)
        }
        
        return items
    }
    
    // MARK: Initialization
    
    init?(queryItems: [URLQueryItem]) {
        var question: String?
        var answer: CorrectionAnswer?
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == Correction.questionQueryName {
                question = value
            } else if let answerType = CorrectionAnswer(rawValue: value) where queryItem.name == Correction.answerQueryName {
                answer = answerType
            }
        }
        
        self.question = question
        self.answer = answer
    }
}

extension CorrectionAnswer: Equatable {}
func ==(lhs: CorrectionAnswer, rhs: CorrectionAnswer) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case (.correct, .correct):
        return true
    case let (.incorrect(lIncorrect), .incorrect(rIncorrect)):
        return lIncorrect == (rIncorrect)
    default:
        return false
    }
}

extension Correction: Equatable {}
func ==(lhs: Correction, rhs: Correction) -> Bool {
    return lhs.question == rhs.question && lhs.answer == rhs.answer
}
