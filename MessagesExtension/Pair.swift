//
//  Translation.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

enum Pair {
    case translation(Translation)
    case correction(Correction)
    
    func type() -> String {
        switch self {
        case .translation(_):
            return "translation"
        case .correction(_):
            return "correction"
        }
    }
}

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

/**
 Extends `Translation` to be able to be represented by and created with an array of
 `NSURLQueryItem`s.
 */
extension Pair {
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(typeQueryItem)
        items.append(contentsOf: bodyQueryItems)
        
        return items
    }
    
    // MARK: Initialization
    
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
    switch (lhs, rhs) {
    case let (.translation(lTranslation), .translation(rTranslation)):
        return lTranslation == rTranslation
    case let (.correction(lCorrection), .correction(rCorrection)):
        return lCorrection == rCorrection
    default:
        return false
    }
}

