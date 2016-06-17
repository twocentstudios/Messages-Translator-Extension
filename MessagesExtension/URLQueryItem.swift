//
//  URLQueryItem.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/17/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Foundation

extension Pair {
    static let typeQueryName = "type"
    
    var typeQueryItem: URLQueryItem {
        return URLQueryItem(name: Pair.typeQueryName, value: type())
    }
    
    var bodyQueryItems: [URLQueryItem] {
        switch self {
        case .translation(let translation):
            return translation.queryItems
        case .correction(let correction):
            return correction.queryItems
        }
    }
}

extension Pair {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(typeQueryItem)
        items.append(contentsOf: bodyQueryItems)
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        var queryType: String?
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == Pair.typeQueryName {
                queryType = value
                break
            }
        }
        
        guard let type = queryType else { return nil }
        
        switch type {
        case "translation":
            guard let translation = Translation(queryItems: queryItems) else { return nil }
            self = .translation(translation)
        case "correction":
            guard let correction = Correction(queryItems: queryItems) else { return nil }
            self = .correction(correction)
        default:
            return nil
        }
    }
}

extension Translation {
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

extension Translation {    
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
    
    init?(queryItems: [URLQueryItem]) {
        var question: String?
        var answer: TranslationAnswer?
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if queryItem.name == Translation.questionQueryName {
                question = value
            } else if let answerType = TranslationAnswer(rawValue: value) where queryItem.name == Translation.answerQueryName {
                answer = answerType
            }
        }
        
        self.question = question
        self.answer = answer
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

extension Correction {
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
