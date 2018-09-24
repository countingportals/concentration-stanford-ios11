//
//  Card.swift
//  Concentration
//
//  Created by Ashley Raines on 9/23/18.
//  Copyright © 2018 Ashley Raines. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var HashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false {
        didSet {
            // if we're flipping the card back over, and this card hasn't been seen before
            if oldValue, !hasBeenSeen {
                // mark this card as seen
                hasBeenSeen = true
            }
        }
    }
    var isMatched = false
    var hasBeenSeen = false
    private let identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
