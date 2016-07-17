//
//  ViewController.swift
//  Fun Facts
//
//  Created by Adam Sigel on 7/7/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

//  TODO:
//  * Fix styling issues for multiple device sizes
//  * Fix guessRightAlert so users can't win points multiple times for the same movie
//  * Add more movies
//  * Allow for fuzzy matching (ignore the word 'the')
//  # 3D touch to see a GIF from the movie

import UIKit

let plotList = PlotList()
let colorWheel = ColorWheel()
var count = 0
var userScoreValue: Int = 0
var movieValue: Int = 0

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userGuess: UITextField!
    @IBOutlet weak var emojiPlot: UILabel!
    @IBOutlet weak var guessFeedback: UILabel!
    @IBOutlet weak var newMovieButton: UIButton!
    @IBOutlet weak var dahFuh: UIButton!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
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
    // answerArray[2] is the hint
    // answerArray[3] is the point value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        emojiPlot.text = answerArray[0]
        print("The secret movie is " + answerArray[1])
        guessFeedback.text = ""
        guessFeedback.backgroundColor = UIColor.clearColor()
        newMovieButton.setTitle("", forState: .Normal)
        movieValue = Int(answerArray[3])!
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
        guessFeedback.text = ""
        guessFeedback.backgroundColor = UIColor.clearColor()
        answerArray = plotList.randomMovie()
        emojiPlot.text = answerArray[0]
        print("The secret movie is " + answerArray[1])
        count = 0
        movieValue = Int(answerArray[3])!
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func checkGuess() {
        let guess = userGuess.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        count = count + 1
        print("User has guessed " + guess!)
        print("User has guessed " + String(count) + " times.")
        if guess == answerArray[1] {
            print("userGuess is correct")
//            dispatch_async(dispatch_get_main_queue(), { () -> () in
//                self.guessFeedback.backgroundColor = self.feedbackBackground
//                self.guessFeedback.textColor = self.goodGuess
//                self.guessFeedback.text = "You got it!"
//                self.newMovieButton.setTitle("Go again?", forState: .Normal)
//                });
            var guessMessageBase = "Great job! You got it in " + String(count)
            let guessOnce = " guess!"
            let guessMany = " guesses!"
            if count == 1 {
                guessMessageBase = guessMessageBase + guessOnce
            } else {
                guessMessageBase = guessMessageBase + guessMany
            }
            let guessRightAlert = UIAlertController(title: "You got it!", message: guessMessageBase, preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "Play again", style: .Default) { (action) in
                self.nextRound()
            }
            let cancelAction = UIAlertAction(title: "Cool", style: .Default) { (action) in
                print("User doesn't want to play anymore.")
            }
            guessRightAlert.addAction(OKAction)
            guessRightAlert.addAction(cancelAction)
            self.presentViewController(guessRightAlert, animated: true, completion: nil)
            userScoreValue = userScoreValue + movieValue
            userScore.text = String(userScoreValue)
        } else {
            print("userGuess is incorrect")
//            dispatch_async(dispatch_get_main_queue(), { () -> () in
//                self.guessFeedback.backgroundColor = self.feedbackBackground
//                self.guessFeedback.textColor = self.badGuess
//                self.guessFeedback.text = "Nope, try again!"
//            });
            let guessWrongAlert = UIAlertController(title: "That's not it", message: "Sorry, that's not the right movie. Guess again.", preferredStyle: UIAlertControllerStyle.Alert)
            guessWrongAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(guessWrongAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func hintButton(sender: AnyObject) {
        print("User has asked for a hint.")
        let alert = UIAlertController(title: "Here's a hint", message: answerArray[2], preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        movieValue = movieValue - 10
    }
    
    @IBAction func dahFuh(sender: AnyObject) {
        print("User wants to know how the game works.")
        let alert = UIAlertController(title: "Dah Fuh?", message: "The emojis tell the plot of a movie. Guess the plot. You can get hints or skip, but that will hurt your score.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func skipMovie(sender: AnyObject) {
        print("User is considering skipping this one.")
        let skipAlert = UIAlertController(title: "Skip this movie?", message: "You can skip this one, but it'll cost you points.", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "Skip", style: .Default) { (action) in
            print("User has chosen the coward's way out.")
            userScoreValue = userScoreValue - 25
            self.userScore.text = String(userScoreValue)
            self.nextRound()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            print("User has chosen to press on bravely.")
        }
        skipAlert.addAction(OKAction)
        skipAlert.addAction(cancelAction)
        self.presentViewController(skipAlert, animated: true, completion: nil)
    }
}

