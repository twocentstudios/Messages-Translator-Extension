//
//  Translation.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

enum PairType: String {
    case Translation
    case Correction
}

struct Pair {
    let type: PairType
    var question: String?
    var answer: String?
    
    var isComplete: Bool {
        return question != nil && answer != nil
    }
}

extension Pair {
    static let typeQueryName = "type"
    static let questionQueryName = "question"
    static let answerQueryName = "answer"
    
    var typeQueryItem: URLQueryItem {
        return URLQueryItem(name: Pair.typeQueryName, value: type.rawValue)
    }
    
    var questionQueryItem: URLQueryItem? {
        guard let question = question else { return nil }
        return URLQueryItem(name: Pair.questionQueryName, value: question)
    }
    
    var answerQueryItem: URLQueryItem? {
        guard let answer = answer else { return nil }
        return URLQueryItem(name: Pair.answerQueryName, value: answer)
    }
}


/**
 Extends `Pair` to be able to be represented by and created with an array of
 `NSURLQueryItem`s.
 */
extension Pair {
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(typeQueryItem)
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
        var type: PairType?
        var question: String?
        var answer: String?
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if let decodedPart = PairType(rawValue: value) where queryItem.name == Pair.typeQueryName {
                type = decodedPart
            } else if queryItem.name == Pair.questionQueryName {
                question = value
            } else if queryItem.name == Pair.answerQueryName {
                answer = value
            }
        }
        
        guard let guardedType = type else { return nil }
        
        self.type = guardedType
        self.question = question
        self.answer = answer
    }
}



/**
 Extends `Pair` to be able to be created with the contents of an `MSMessage`.
 */
extension Pair {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}

extension Pair: Equatable {}
func ==(lhs: Pair, rhs: Pair) -> Bool {
    return lhs.type == rhs.type && lhs.question == rhs.question && lhs.answer == rhs.answer
}
