//
//  AddMovieController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/3/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import Firebase

var dateString = ""

class AddMovieController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userSubmitTitle: UITextField!
    @IBOutlet weak var userSubmitPlot: UITextField!
    @IBOutlet weak var userSubmitMovieButton: UIButton!

    @IBAction func userSubmitMovie (_ sender: AnyObject) {
        // Alert View for input
        self.currentDate()
        let userTitle = userSubmitTitle.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userPlot = userSubmitPlot.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "", addedDate: dateString, addedByUser: user.email, approved: 0, points: 0)
        let refMovies = ref.child("movies/")
        let moviePlotRef = refMovies.childByAutoId()
        let userData = User(uid: 0, email: "adsigel@gmail.com", displayName: "Adam Sigel", score: userScoreValue)
        let userRef = ref.child("users/" + user.displayName)
        moviePlotRef.setValue(movieData.toAnyObject())
        userRef.setValue(userData.toAnyObjectUser())
        var movieId = moviePlotRef.key
        print("The new movie has been added with uid of: " + movieId)
        // confirmSave()
    
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

    func confirmSave() {
        print("** Saving new movie to Firebase...")
        let confirmAlert = UIAlertController(title: "Movie submitted", message: "Thank you for submitting this movie.", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print("** User has acknowledged that movie is added to Firebase.")
        }
        confirmAlert.addAction(OKAction)
        self.presentViewController(confirmAlert, animated: true, completion: nil)
    }
}
