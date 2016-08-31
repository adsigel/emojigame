//
//  AddMovieController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/3/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import Firebase
import Mixpanel

var dateString = ""
var uid = ""
var omdbResult = [String: String]()
var foundTitle = ""
var foundAwards = ""
var foundBox = ""
var foundDirector = ""
var foundGenre = ""
var foundPlot = ""
var foundYear = ""

class AddMovieController: UIViewController, UITextFieldDelegate, OMDBAPIControllerDelegate {

    @IBOutlet weak var userSubmitTitle: UITextField!
    @IBOutlet weak var userSubmitPlot: UITextField!
    @IBOutlet weak var userSubmitMovieButton: UIButton!
    
    // Lazy Stored Property
    lazy var apiController: OMDBAPIController = OMDBAPIController(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.delegate = self
        userSubmitTitle.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
    }
    
    @IBAction func goBackButton(sender: AnyObject) {
        performSegueWithIdentifier("finishAddingMovie", sender: sender)
    }
    
    func textFieldDidEndEditing(userSubmitPlot: UITextField) {
        apiController.searchOMDB(userSubmitPlot.text!)
    }
    
    @IBAction func userSubmitMovie (_ sender: AnyObject) {
        self.currentDate()
        let userTitle = userSubmitTitle.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userPlot = userSubmitPlot.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let characterSetNotAllowed = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyz")
        let rangeOfCharacter = userPlot!.rangeOfCharacterFromSet(characterSetNotAllowed, options: .CaseInsensitiveSearch)
        
        if userTitle != "" && userPlot != "" {
            let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "", addedDate: dateString, addedByUser: uzer, approved: 0, points: 0)
            let refMovies = ref.child("movies/")
            let moviePlotRef = refMovies.childByAutoId()
            moviePlotRef.setValue(movieData.toAnyObject())
            var movieId = moviePlotRef.key
            userRef.child(uzer).child("submitted/").child(movieId).setValue(dateString)
            Mixpanel.mainInstance().track(event: "Movie Submitted")
            print("The new movie has been added with an id of: \(movieId)")
            performSegueWithIdentifier("finishAddingMovie", sender: sender)
        } else {
            let badSubmitAlert = UIAlertController(title: "Something's Missing", message: "Erm, you need to provide a movie title and a plot for us to review.", preferredStyle: UIAlertControllerStyle.Alert)
            badSubmitAlert.addAction(UIAlertAction(title: "Gotcha", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(badSubmitAlert, animated: true, completion: nil)

        }
    }
    
    @IBAction func addMovieHelp(sender: AnyObject) {
        let helpAlert = UIAlertController(title: "Enabling the Emoji Keyboard", message: "You must have the emoji keyboard enabled to submit a plot. Do you need help with that?", preferredStyle: UIAlertControllerStyle.Alert)
        let good = UIAlertAction(title: "I'm good", style: .Default) { (action) in
            print("User claims to know how emoji work.")
        }
        let help = UIAlertAction(title: "Help me", style: .Default) { (action) in
            let url = NSURL(string: "http://emojisodes.com/help")!
            UIApplication.sharedApplication().openURL(url)

        }
        helpAlert.addAction(good)
        helpAlert.addAction(help)        
        self.presentViewController(helpAlert, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func currentDate() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        dateString = dateformatter.stringFromDate(NSDate())
    }
    
    func didFinishOMDBSearch(result: Dictionary<String, String>) {
        
        if let foundTitle = result["Title"] {
            print("Title is \(foundTitle)")
        }
        
        if let foundActors = result["Actors"] {
            print("Starring \(foundActors)")
        }
        
        if let foundYear = result["Year"] {
            print("Released in \(foundYear)")
        } else {
            print("Could not find release date")
        }
        
        if let foundGenre = result["Genre"] {
            print("Categorized as \(foundGenre)")
        } else {
            print("Could not find genres")
        }
        
    }
    
}
