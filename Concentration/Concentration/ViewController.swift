//
//  ViewController.swift
//  Concentration
//
//  Created by Ashley Raines on 9/21/18.
//  Copyright © 2018 Ashley Raines. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // not private because get only
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    // only private for setting
    private(set) var currentGameFlipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(currentGameFlipCount)"
        }
    }
    
    private(set) var currentGameScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentGameScore)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }
        }
        currentGameScore = game.currentScore
        currentGameFlipCount = game.flipCount
    }
    
    private let themes = [
        "geek": ["👾", "🤖", "👽", "🧟‍♀️", "🧙🏾‍♂️", "🧝🏻‍♀️", "🧛🏻‍♂️", "🧜🏽‍♀️", "🧞‍♂️"],
        "halloween": ["🎃", "🐱", "🧛🏻‍♂️", "🧟‍♀️", "🍬", "🧙🏻‍♀️", "🦇", "🕷", "🕸"],
        "hp": ["⚡️", "🧙🏾‍♂️", "🐍", "🦌", "🏰", "🏆", "⏳", "🗝", "🌳"],
        "space": ["🌗", "🌙", "🌞", "💫", "☄️", "🌎", "🚀", "🛸", "🛰"],
        "city": ["🕍", "🏭", "🕌", "⛩", "⛪️", "🏢", "🏨", "🏦", "🏠"],
        "flags": ["🇷🇪", "🇸🇨", "🇵🇷", "🇨🇦", "🇺🇸", "🇱🇨", "🇲🇴", "🇲🇰", "🇩🇲"]
    ]
    
    private var emoji = [Int:String]()
    
    private lazy var selectedTheme = themes.randomElement()!.value
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, selectedTheme.count > 0 {
            emoji[card.identifier] = selectedTheme.remove(at: selectedTheme.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        currentGameFlipCount = game.flipCount
        currentGameScore = game.currentScore
        selectedTheme = themes.randomElement()!.value
        updateViewFromModel()
    }
    
}

// extending Int class to return a random number given an integer
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}
