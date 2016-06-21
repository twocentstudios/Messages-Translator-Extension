//
//  Pair.swift
//  messagesbeta
//
//  Created by Christopher Trott on 6/14/16.
//  Copyright © 2016 twocentstudios. All rights reserved.
//

import Messages

// Top level model enum that represents a question/answer pair in either
// translation or correction type.
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

