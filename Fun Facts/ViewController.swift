//
//  ViewController.swift
//  Fun Facts
//
//  Created by Adam Sigel on 7/7/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

//  TODO:
//  * Fix styling issues for multiple device sizes
//  * Show another movie when a user is right
//  * Count user guesses
//  * Track correct guesses
//  * Share movie
//  * Add more movies

import UIKit

let plotList = PlotList()
let colorWheel = ColorWheel()

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userGuess: UITextField!
    @IBOutlet weak var emojiPlot: UILabel!
    @IBOutlet weak var guessFeedback: UILabel!
    @IBOutlet weak var newMovieButton: UIButton!
    
    func textFieldShouldReturn(userGuess: UITextField!) -> Bool {
        userGuess.resignFirstResponder()
        checkGuess()
        return true
    }
    
    let badGuess = UIColor(red: 242/255, green: 119/255, blue: 119/255, alpha: 1.0)
    let goodGuess = UIColor(red: 166/255, green: 242/255, blue: 119/255, alpha: 1.0)
    let feedbackBackground = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
    var answerArray = plotList.randomMovie()
    // answerArray[0] is the emoji plot
    // answerArray[1] is the secret title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        emojiPlot.text = answerArray[0]
        print("The secret movie is " + answerArray[1])
        guessFeedback.text = ""
        guessFeedback.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextRound() {
//        var randomColor = colorWheel.randomColor()
//        view.backgroundColor = randomColor
//        newMovieButton.tintColor = randomColor
        print("User wants another movie.")
        userGuess.text = ""
        answerArray = plotList.randomMovie()
        emojiPlot.text = answerArray[0]
        print("The secret movie is " + answerArray[1])
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func checkGuess() {
        var guess = userGuess.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print("User has guessed " + guess!)
        if guess == answerArray[1] {
            print("userGuess is correct")
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                self.guessFeedback.backgroundColor = self.feedbackBackground
                self.guessFeedback.textColor = self.goodGuess
                self.guessFeedback.text = "You got it!"
                });
        } else {
            print("userGuess is incorrect")
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                self.guessFeedback.backgroundColor = self.feedbackBackground
                self.guessFeedback.textColor = self.badGuess
                self.guessFeedback.text = "Nope, try again!"
            });
        }
        
    }
}

