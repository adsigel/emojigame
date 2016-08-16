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
var uid = ""

class AddMovieController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userSubmitTitle: UITextField!
    @IBOutlet weak var userSubmitPlot: UITextField!
    @IBOutlet weak var userSubmitMovieButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginController().currentUser(uid)
        print("user's ID is \(uid)")
    }
    
    
    @IBAction func userSubmitMovie (_ sender: AnyObject) {
        // Alert View for input
        self.currentDate()
        let userTitle = userSubmitTitle.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userPlot = userSubmitPlot.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "", addedDate: dateString, addedByUser: uid, approved: 0, points: 0)
        let refMovies = ref.child("movies/")
        let moviePlotRef = refMovies.childByAutoId()
        moviePlotRef.setValue(movieData.toAnyObject())
        var movieId = moviePlotRef.key
        print("The new movie has been added with an id of: \(movieId)")
    
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

}
