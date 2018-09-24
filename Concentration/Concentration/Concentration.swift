//
//  Concentration.swift
//  Concentration
//
//  Created by Ashley Raines on 9/23/18.
//  Copyright © 2018 Ashley Raines. All rights reserved.
//

import Foundation

class Concentration {
    
    // makes array a constant for outside this class
    private(set) var cards = [Card]()
    
    private(set) var flipCount: Int
    
    private(set) var currentScore: Int
    
    private(set) var lastTimeTouched: Date?
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        // crash when improperly used
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        flipCount += 1
        
        if !cards[index].isMatched {
            // no cards are face up
            // two cards are face up and either match or do not
            // one card is face up
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match assuming the card is not the same one last tapped
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    // gain 2 points for a match
                    adjustScore(by: 2, considerTime: true)
                } else {
                    // lose 1 point for each card that has been flipped over before
                    var penalty = cards[matchIndex].hasBeenSeen ? 1 : 0;
                    penalty += cards[index].hasBeenSeen ? 1 : 0;
                    // this card has been seen and at least 2 cards are faceup
                    adjustScore(by: -penalty)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        lastTimeTouched = Date()
    }
    
    private func adjustScore(by amount: Int, considerTime: Bool = false) {
        currentScore += amount
        
        // lose points for every 2 seconds between last match and this
        if considerTime {
            currentScore += Int(lastTimeTouched!.timeIntervalSinceNow/2)
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        // crash when improperly used
        assert(numberOfPairsOfCards > 0, "init(numberOfPairsOfCards: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
        currentScore = 0
        flipCount = 0
    }
}

// extending Collection protocol to get one match
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
