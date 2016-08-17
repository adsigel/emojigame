//
//  ViewController.swift
//  Fun Facts
//
//  Created by Adam Sigel on 7/7/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

//  TODO:
//  * Allow for fuzzy matching (e.g. ignore the word 'the') https://github.com/firebase/flashlight
//  ? 3D touch to see a GIF from the movie
//  * Refactor and move functions into the proper models/classes
//  * Add levels and badges based on user score
//  * Save excludeArray to user profile so they don't see the same movies in different sessions - FINISH TESTING

import UIKit
import Firebase
import TwitterKit
import CoreFoundation

let ref = FIRDatabase.database().reference()
let movieRef = ref.child("movies")
let userRef = ref.child("users")
var count = 0
var userScoreValue = userDict["score"] as! Int
var userGuess = String()
var movieValue: Int = 0
var excludeIndex = [String]()
var movie = [Movies]()
var movieIDArray = [String]()
var user: User!
var movieToGuess = String()
var movieID = String()
var movieDict = [String: AnyObject]()
var secretTitle = String()
var secretHint = String()
var secretPlot = String()
var secretValue: Int = 0
var moviesPlayed = ""

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userGuess: UITextField!
    @IBOutlet weak var emojiPlot: UILabel!
    @IBOutlet weak var dahFuh: UIButton!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    func textFieldShouldReturn(_ userGuess: UITextField!) -> Bool {
        userGuess.resignFirstResponder()
        checkGuess()
        return true
    }
    
    let badGuess = UIColor(red: 242/255, green: 119/255, blue: 119/255, alpha: 1.0)
    let goodGuess = UIColor(red: 166/255, green: 242/255, blue: 119/255, alpha: 1.0)
    let feedbackBackground = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.randomKeyfromFIR{ (movieToGuess) -> () in
            self.getMovieData(movieToGuess)
        }
        self.userScore.text = String(userDict["score"]!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextRound() {
        print("User wants another movie.")
        userGuess.text = ""
        self.randomKeyfromFIR{ (movieToGuess) -> () in
            self.getMovieData(movieToGuess)
        }
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
        if guess == movieDict["title"] as! String {
            print("userGuess is correct")
            movieDict["points"] as! Int
            var guessMessageBase = "You got it in " + String(count)
            let guessOnce = " guess and earned \(movieValue) points."
            let guessMany = " guesses and earned  \(movieValue) points."
            if count == 1 {
                guessMessageBase = guessMessageBase + guessOnce
            } else {
                guessMessageBase = guessMessageBase + guessMany
            }
            let guessRightAlert = UIAlertController(title: "That's it!", message: guessMessageBase, preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "Next movie", style: .Default) { (action) in
                self.nextRound()
                var newScore: Int = userDict["score"] as! Int
                newScore = newScore + movieValue
                userDict["score"] = newScore
                self.userScore.text = String(userDict["score"]!)
                // updates user score in db
                userRef.child(uid).child("score").setValue(newScore)
                // adds new child to /exclude with movie key
                userRef.child(uid).child("exclude").child(movieToGuess).setValue(true)
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
    
    @IBAction func hintButton(_ sender: AnyObject) {
        print("User has asked for a hint.")
        let alert = UIAlertController(title: "Here's a hint", message: movieDict["hint"]! as! String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        movieValue = Int(movieDict["points"]! as! NSNumber) - 10
    }
    
    @IBAction func dahFuh(_ sender: AnyObject) {
        print("User wants to know how the game works.")
        let alert = UIAlertController(title: "What is this?", message: "The emojis tell the plot of a movie (not the title). Guess the correct movie and win points. You can get hints or skip, but that will hurt your score.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func skipMovie(_ sender: AnyObject) {
        print("User is considering skipping this one.")
        let skipAlert = UIAlertController(title: "Skip this movie?", message: "You can skip this one, but it'll cost you 25 points. Are you sure you want to skip?", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "I'm sure", style: .Default) { (action) in
            print("User has chosen the coward's way out.")
            userScoreValue = userScoreValue - 25
            self.userScore.text = String(userScoreValue)
            self.randomKeyfromFIR{ (movieToGuess) -> () in
                self.getMovieData(movieToGuess)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            print("User has chosen to press on bravely.")
        }
        skipAlert.addAction(OKAction)
        skipAlert.addAction(cancelAction)
        self.presentViewController(skipAlert, animated: true, completion: nil)
    }
    @IBAction func shareButton(_ sender: AnyObject) {
        let textToShare = "Can you guess what movie this is? " + (movieDict["plot"]! as! String)
        
        if let myWebsite = NSURL(string: "http://emojisodes.com") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func randomKeyfromFIR (completion:String -> ()) {
        var movieCount = 0
        movieIDArray = []
        movieRef.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let movieItem = Movies(snapshot: item as! FIRDataSnapshot)
                movieID = movieItem.key!
                let approved = movieItem.approved
                if approved == 1 {
                    movieIDArray.append(movieID)
                    movieCount = Int(movieIDArray.count)
                }
            }
            var randomIndex : Int = 0
            let moviePlayed = userDict["exclude"] as! [String:AnyObject]
            var moviePlayedKeys = Array(moviePlayed.keys)
            print("Here is moviePlayedKeys: \(moviePlayedKeys)")
            randomIndex = Int(arc4random_uniform(UInt32(movieCount)))
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(movieCount)))
                movieToGuess = movieIDArray[randomIndex]
                print("movieToGuess is \(movieToGuess)")
            } while moviePlayedKeys.contains(movieToGuess)
            movieToGuess = movieIDArray[randomIndex]
            // Check to see if user has played that movie before
//            excludeIndex.append(movieToGuess)
//            if excludeIndex.count == movieCount {
//                excludeIndex = []
//            }
            
            completion(movieToGuess)

            })
    }

    
    func getMovieData(movieToGuess:String) {
        let movieToGuessRef = movieRef.ref.child(movieToGuess)
        movieToGuessRef.observeEventType(.Value, withBlock: { (snapshot) in
            movieDict = snapshot.value as! [String : AnyObject]
            var plot = movieDict["plot"] as! String
            self.emojiPlot.text = plot
            movieValue = movieDict["points"] as! Int
        })
    }

    
    @IBAction func signOut(sender: AnyObject) {
        do {
            try! FIRAuth.auth()!.signOut()
            print("User \(uid) logging out")
            self.performSegueWithIdentifier("logOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}

