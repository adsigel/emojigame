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
import Firebase

let ref = FIRDatabase.database().reference()
let movieRef = ref.child("movies")
let userRef = ref.child("users")
let plotList = PlotList()
let colorWheel = ColorWheel()
var count = 0
var userScoreValue: Int = 0
var movieValue: Int = 0
var excludeArray = [0]
var excludeIndex = [Int]()
var movie = [Movies]()
var movieIDArray = [String]()
var user: User!
var movieID = ""
var randomIndex : Int = 0
var movieToGuess = ""
var movieDict = [String: AnyObject]()

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
    var answerArray = []
    // answerArray[0] is the emoji plot
    // answerArray[1] is the secret title
    // answerArray[2] is the hint
    // answerArray[3] is the point value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        selectMovie()
        randomKeyfromFIR()
        var testArray = [String]()
        movieRef.queryOrdered(byChild: "approved").queryEqual(toValue: "true").observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                for child in snapshot.children {
                    let key = child.value["plot"] as! String
                    testArray.append(key)
                }
                print("** here is the test output: \(testArray)")
            }
            //for movie in snapshot.children {
            //    let movies = movie as! FIRDataSnapshot
            //    movieCount = Int(movies.childrenCount)
            //    movieIDArray.append(movies.key)
            //}
        })
        user = User(uid: 0, email: "adsigel@gmail.com", displayName: "Adam Sigel", score: userScoreValue)
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
        let guess = userGuess.text?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
            let guessRightAlert = UIAlertController(title: "That's it!", message: guessMessageBase, preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "Next movie", style: .default) { (action) in
                self.nextRound()
            }
            guessRightAlert.addAction(OKAction)
            self.present(guessRightAlert, animated: true, completion: nil)
        } else {
            print("userGuess is incorrect")
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( caTransform3D:CATransform3DMakeTranslation(-10, 0, 0 ) ),
                NSValue( caTransform3D:CATransform3DMakeTranslation( 10, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            userGuess.layer.add( anim, forKey:nil )
        }
        
    }
    
    @IBAction func hintButton(_ sender: AnyObject) {
        print("User has asked for a hint.")
        let alert = UIAlertController(title: "Here's a hint", message: answerArray[2] as! String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        movieValue = movieValue - 10
    }
    
    @IBAction func dahFuh(_ sender: AnyObject) {
        print("User wants to know how the game works.")
        let alert = UIAlertController(title: "What is this?", message: "The emojis tell the plot of a movie (not the title). Guess the correct movie and win points. You can get hints or skip, but that will hurt your score.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func skipMovie(_ sender: AnyObject) {
        print("User is considering skipping this one.")
        let skipAlert = UIAlertController(title: "Skip this movie?", message: "You can skip this one, but it'll cost you 25 points. Are you sure you want to skip?", preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "I'm sure", style: .default) { (action) in
            print("User has chosen the coward's way out.")
            userScoreValue = userScoreValue - 25
            self.userScore.text = String(userScoreValue)
            self.randomKeyfromFIR()
            self.getMovieData()

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("User has chosen to press on bravely.")
        }
        skipAlert.addAction(OKAction)
        skipAlert.addAction(cancelAction)
        self.present(skipAlert, animated: true, completion: nil)
    }
    @IBAction func shareButton(_ sender: AnyObject) {
        let textToShare = "Can you guess what movie this is? " + (answerArray[0] as! String)
        
        if let myWebsite = URL(string: "http://adamdsigel.com") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func selectMovie() {
        answerArray = plotList.randomMovie()
        emojiPlot.text = answerArray[0] as! String
        print("The secret movie is " + (answerArray[1] as! String))
        print("Movies excluded are in positions" + String(excludeArray))
        movieValue = Int(answerArray[3] as! String)!
    }
    
    
    
    
    
    func randomKeyfromFIR () -> String {
        var movieCount = 0
        movieRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            for movie in snapshot.children {
                let movies = movie as! FIRDataSnapshot
                movieCount = Int(movies.childrenCount)
                movieIDArray.append(movies.key)
            }
            print("** here is the count of movies: \(movieCount)")
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(movieCount)))
            } while excludeIndex.contains(randomIndex)
            movieToGuess = movieIDArray[randomIndex]
            print("** The key for the secret movie is.... " + movieToGuess + " **")
            excludeIndex.append(randomIndex)
            if excludeIndex.count == movieIDArray.count {
                excludeIndex = [Int]()
            }
            print("** here is the random number: \(randomIndex)")
            let arrayLength = movieIDArray.count
            print("** movieIDArray is now: \(movieIDArray)")
            print("** Indexes to exclude are... \(excludeIndex)")
            
            
            // TODO: Separate initial Firebase retrieval from random movie key selection
            // movieArray is growing with each repeat of the loop
            // TODO: Make sure the initial retrieval actually pulls ALL movies
            // TODO: Make sure the initial retrieval filters on approved: true
            
        })
        return movieToGuess
    }
    
    func getMovieData() -> [String : AnyObject] {
        // define node where child data will be retrieved based on movieToGuess
        let movieToGuessRef = movieRef.ref.child(movieToGuess)
        movieToGuessRef.observe(FIRDataEventType.value, with: { (snapshot) in
        // retrieve all child data and store in a dictionary
            movieDict = snapshot.value as! [String : AnyObject]
            let secretPlot = movieDict["plot"] as! String
            print("** here is movieStuff: \(movieDict)")
            print("** here is the secret movie plot: " + secretPlot)
            self.emojiPlot.text = secretPlot
            })
        return movieDict
    }
    }

