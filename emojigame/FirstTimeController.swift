//
//  FirstTimeController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/24/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit
import Mixpanel

class FirstTimeController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var explainerText: UILabel!
    @IBOutlet weak var doTogether: UILabel!
    @IBOutlet weak var checkMark: UIButton!
    
    
    override func viewDidLoad() {
        Mixpanel.mainInstance().time(event: "Onboarding")
        self.explainerText.text = "It's a 🎬 plot guessing game with 😀👍."
    }
    
    
    @IBAction func nextButton(sender: AnyObject) {
        let step1 = "It's a 🎬 plot guessing game with 😀👍."
        let step2 = "We'll show you a bunch of 👱👩💔☔️💑 that represent the plot of a 🎬."
        let step3 = "You can 🤔 for hints, but it will cost you points."
        let step4 = "If the hints aren't helpful, try 💌 with friends."
        let step5 = "If all else fails, you can 🚫 for now, but that also costs points."
        let step6 = "You can ➕ to Emojisodes with your own 🎬 too!"
        
        if self.explainerText.text == step1 {
            self.explainerText.text = step2
            }
        else if self.explainerText.text == step2 {
            self.explainerText.text = step3
            }
        else if self.explainerText.text == step3 {
            self.explainerText.text = step4
            }
        else if self.explainerText.text == step4 {
            self.explainerText.text = step5
            }
        else if self.explainerText.text == step5 {
            self.explainerText.text = step6
            }
        else if self.explainerText.text == step6 {
            self.doTogether.hidden = false
            self.checkMark.hidden = false
            }
        }
    
    
    @IBAction func checkMarkButton(sender: AnyObject) {
        performSegueWithIdentifier("tryOne", sender: sender)
    }
    
    
}