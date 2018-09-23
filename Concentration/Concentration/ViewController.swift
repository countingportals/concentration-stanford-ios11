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
    
    // Action that happens on touch of a card
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            // calls Concentration.chooseCard
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    // Update the current view
    private func updateViewFromModel(){
        // looping through each card
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            // if it is faceup, change the background and set the emoji
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // otherwise it is face down
                button.setTitle("", for: .normal)
                // if matched, make the card go away, otherwise flip over
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardColor
            }
        }
        // update the current score and flip counts
        currentGameScore = game.currentScore
        currentGameFlipCount = game.flipCount
    }
    
    private let themes = [
        "geek": (emojis: ["👾", "🤖", "👽", "🧟‍♀️", "🧙🏾‍♂️", "🧝🏻‍♀️", "🧛🏻‍♂️", "🧜🏽‍♀️", "🧞‍♂️"], background: #colorLiteral(red: 0.8036000476, green: 0.9329358017, blue: 1, alpha: 1), cardColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        "halloween": (emojis: ["🎃", "🐱", "🧛🏻‍♂️", "🧟‍♀️", "🍬", "🧙🏻‍♀️", "🦇", "🕷", "🕸"], background: #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1), cardColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)),
        "hp": (emojis: ["⚡️", "🧙🏾‍♂️", "🐍", "🦌", "🏰", "🏆", "⏳", "🗝", "🌳"], background: #colorLiteral(red: 1, green: 0.9190665049, blue: 0.8584312549, alpha: 1), cardColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)),
        "space": (emojis: ["🌗", "🌙", "🌞", "💫", "☄️", "🌎", "🚀", "🛸", "🛰"], background: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), cardColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        "city": (emojis: ["🕍", "🏭", "🕌", "⛩", "⛪️", "🏢", "🏨", "🏦", "🏠"], background: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cardColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
        "flags": (emojis: ["🇷🇪", "🇸🇨", "🇵🇷", "🇨🇦", "🇺🇸", "🇱🇨", "🇲🇴", "🇲🇰", "🇩🇲"], background: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cardColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    ]
    
    private var emoji = [Int:String]()
    
    private var selectedTheme = (emojis: [""], background: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), cardColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    
    private var cardColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // Assign emoji to our cards
    private func emoji(for card: Card) -> String {
        // If we don't have an identifier and we still have items in our theme array
        if emoji[card.identifier] == nil, selectedTheme.emojis.count > 0 {
            // assign a random emoji to this card identifier
            emoji[card.identifier] = selectedTheme.emojis.remove(at: selectedTheme.emojis.count.arc4random)
        }
        // return identifier or ? if nil
        return emoji[card.identifier] ?? "?"
    }
    
    // Resets the game
    @IBAction private func newGame(_ sender: UIButton) {
        // get a new instance of Concentration
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        // reset the flip count
        currentGameFlipCount = game.flipCount
        // reset the score
        currentGameScore = game.currentScore
        // update the theme
        updateTheme()
        // update the view to reflect all of these changes
        updateViewFromModel()
    }
    
    // Resets all variables pertaining to a new theme
    private func updateTheme(){
        // selects a random theme
        selectedTheme = themes.randomElement()!.value
        // applies the background color
        view.backgroundColor = selectedTheme.background
        // applies the card color
        cardColor = selectedTheme.cardColor
        for card in cardButtons {
            card.backgroundColor = selectedTheme.cardColor
        }
    }
    
    // override initial load to update with random theme
    override func loadView() {
        super.loadView()
        updateTheme()
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
