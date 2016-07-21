//
//  ViewController.swift
//  Fun Facts
//
//  Created by Adam Sigel on 7/7/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

//  TODO:
//  * Add more movies
//  * Allow for fuzzy matching (ignore the word 'the')
//  * 3D touch to see a GIF from the movie
//  * Figure out why Shawshank emojis get cut off
//  * Refactor and pull functions out of core game logic
//  * Implement MySQL database
//  * Add levels and badges based on user score

import UIKit

let plotList = PlotList()
let colorWheel = ColorWheel()
var count = 0
var userScoreValue: Int = 0
var movieValue: Int = 0
var excludeArray = [0]

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userGuess: UITextField!
    @IBOutlet weak var emojiPlot: UILabel!
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
    var answerArray = []
    // answerArray[0] is the emoji plot
    // answerArray[1] is the secret title
    // answerArray[2] is the hint
    // answerArray[3] is the point value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        selectMovie()
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
        selectMovie()
        count = 0
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
        if guess! == answerArray[1] as! String {
            print("userGuess is correct")
            var guessMessageBase = "You got it in " + String(count)
            let guessOnce = " guess and earned " + String(movieValue) + " points."
            let guessMany = " guesses and earned  " + String(movieValue) + " points."
            if count == 1 {
                guessMessageBase = guessMessageBase + guessOnce
            } else {
                guessMessageBase = guessMessageBase + guessMany
            }
            let guessRightAlert = UIAlertController(title: "That's it!", message: guessMessageBase, preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "Next movie", style: .Default) { (action) in
                self.nextRound()
            }
            guessRightAlert.addAction(OKAction)
            self.presentViewController(guessRightAlert, animated: true, completion: nil)
        } else {
            print("userGuess is incorrect")
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( CATransform3D:CATransform3DMakeTranslation(-10, 0, 0 ) ),
                NSValue( CATransform3D:CATransform3DMakeTranslation( 10, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            userGuess.layer.addAnimation( anim, forKey:nil )
        }
        
    }
    
    @IBAction func hintButton(sender: AnyObject) {
        print("User has asked for a hint.")
        let alert = UIAlertController(title: "Here's a hint", message: answerArray[2] as! String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        movieValue = movieValue - 10
    }
    
    @IBAction func dahFuh(sender: AnyObject) {
        print("User wants to know how the game works.")
        let alert = UIAlertController(title: "What is this?", message: "The emojis tell the plot of a movie (not the title). Guess the correct movie and win points. You can get hints or skip, but that will hurt your score.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func skipMovie(sender: AnyObject) {
        print("User is considering skipping this one.")
        let skipAlert = UIAlertController(title: "Skip this movie?", message: "You can skip this one, but it'll cost you 25 points. Are you sure you want to skip?", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "I'm sure", style: .Default) { (action) in
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
    @IBAction func shareButton(sender: AnyObject) {
        let textToShare = "Can you guess what movie this is? " + (answerArray[0] as! String)
        
        if let myWebsite = NSURL(string: "http://adamdsigel.com") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func selectMovie() {
        answerArray = plotList.randomMovie()
        emojiPlot.text = answerArray[0] as! String
        print("The secret movie is " + (answerArray[1] as! String))
        print("Movies excluded are in positions" + String(excludeArray))
        movieValue = Int(answerArray[3] as! String)!
    }
    
    func updateScore() {
        userScoreValue = userScoreValue + movieValue
        if userScoreValue >= levelOne {
            let levelUpAlert = UIAlertController(title: "New Level Achieved", message: "You are The Emojinator, sent here from the future to match emojis and movies.", preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "Share", style: .Default) { (action) in
                print("User wants to brag about an achievement.")
            }
            let cancelAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
                print("User has chosen to celebrate in silence.")
            }
            levelUpAlert.addAction(OKAction)
            levelUpAlert.addAction(cancelAction)
            self.presentViewController(levelUpAlert, animated: true, completion: nil)
        }
        userScore.text = String(userScoreValue)
        
    }
    
}

