//
//  ViewController.swift
//  Concentration
//
//  Created by Ashley Andersen on 9/21/18.
//  Copyright © 2018 Ashley Andersen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCard(withEmoji: "👾", on: sender)
    }
    
    
    @IBAction func touchSecondCard(_ sender: UIButton) {
        flipCard(withEmoji: "🤖", on: sender)
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        } else {
            button.setTitle(emoji, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    }
    
}

