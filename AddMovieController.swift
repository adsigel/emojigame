//
//  AddMovieController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/3/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import Firebase

class AddMovieController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userSubmitTitle: UITextField!
    @IBOutlet weak var userSubmitPlot: UITextField!
    @IBOutlet weak var userSubmitMovieButton: UIButton!

    @IBAction func userSubmitMovie (sender: AnyObject) {
        // Alert View for input
        self.currentDate()
        let userTitle = userSubmitTitle.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userPlot = userSubmitPlot.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "hint", addedDate: dateString, addedByUser: user.email, approved: false)
        let moviePlotRef = ref.child("movies/" + userTitle!)
        let userData = User(uid: 0, email: "adsigel@gmail.com", displayName: "Adam Sigel", score: userScoreValue)
        let userRef = ref.child("users/" + user.displayName)
        moviePlotRef.setValue(movieData.toAnyObject())
        userRef.setValue(userData.toAnyObjectUser())
        
    
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func currentDate() {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        var dateString = dateFormatter.stringFromDate(currentDate)
    }

    
}
