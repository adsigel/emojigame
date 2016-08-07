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
        let userTitle = userSubmitTitle.text?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let userPlot = userSubmitPlot.text?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "hint", addedDate: dateString, addedByUser: user.email, approved: false, points: 0)
        let refMovies = ref.child("movies/")
        let moviePlotRef = refMovies.childByAutoId()
        let userData = User(uid: 0, email: "adsigel@gmail.com", displayName: "Adam Sigel", score: userScoreValue)
        let userRef = ref.child("users/" + user.displayName)
        moviePlotRef.setValue(movieData.toAnyObject())
        userRef.setValue(userData.toAnyObjectUser())
        var movieId = moviePlotRef.key
        print("The new movie has been added with uid of: " + movieId)
        confirmSave()
    
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func currentDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateString = dateFormatter.string(from: currentDate)
    }

    func confirmSave() {
        print("** Saving new movie to Firebase...")
        let confirmAlert = UIAlertController(title: "Movie submitted", message: "Thank you for submitting this movie.", preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("** User has acknowledged that movie is added to Firebase.")
        }
        confirmAlert.addAction(OKAction)
        self.present(confirmAlert, animated: true, completion: nil)
    }
}
