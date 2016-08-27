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
    }
    
    @IBAction func goBackButton(sender: AnyObject) {
        performSegueWithIdentifier("finishAddingMovie", sender: sender)
    }
    
    @IBAction func userSubmitMovie (_ sender: AnyObject) {
        self.currentDate()
        let userTitle = userSubmitTitle.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userPlot = userSubmitPlot.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if userTitle != "" && userPlot != "" {
            let movieData = Movies(title: userTitle!, plot: userPlot!, hint: "", addedDate: dateString, addedByUser: uzer, approved: 0, points: 0)
            let refMovies = ref.child("movies/")
            let moviePlotRef = refMovies.childByAutoId()
            moviePlotRef.setValue(movieData.toAnyObject())
            var movieId = moviePlotRef.key
            userRef.child(uzer).child("submitted/").child(movieId).setValue(dateString)
            print("The new movie has been added with an id of: \(movieId)")
            performSegueWithIdentifier("finishAddingMovie", sender: sender)
        } else {
            let badSubmitAlert = UIAlertController(title: "Something's Missing", message: "Erm, you need to provide a movie title and a plot for us to review.", preferredStyle: UIAlertControllerStyle.Alert)
            badSubmitAlert.addAction(UIAlertAction(title: "Gotcha", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(badSubmitAlert, animated: true, completion: nil)

        }
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
