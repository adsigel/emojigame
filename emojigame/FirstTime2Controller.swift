//
//  FirstTime2Controller.swift
//  emojigame
//
//  Created by Adam Sigel on 8/24/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirstTime2Controller: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var guessTextField: UITextField!
    
    @IBOutlet weak var helpText: UILabel!
    
    func textFieldShouldReturn(_ guessTextField: UITextField!) -> Bool {
        guessTextField.resignFirstResponder()
        checkGuess()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func goToNext(sender: AnyObject) {
        performSegueWithIdentifier("readyToPlay", sender: sender)
    }
    
    @IBAction func userHelpButton(sender: AnyObject) {
        helpText.hidden = false
    }
    
    
    @IBAction func checkGuess() {
        let guess = guessTextField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if guess == "titanic" {
            let guessRightAlert = UIAlertController(title: "You got it!", message: "You're ready to play Emojisodes now!", preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "I'm Ready", style: .Default) { (action) in
                userRef.child(uzer).child("new_in_town").setValue("false")
                self.goToNext(UIButton)
            }
            guessRightAlert.addAction(OKAction)
            self.presentViewController(guessRightAlert, animated: true, completion: nil)
        } else {
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( CATransform3D:CATransform3DMakeTranslation(-10, 0, 0 ) ),
                NSValue( CATransform3D:CATransform3DMakeTranslation( 10, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            guessTextField.layer.addAnimation( anim, forKey:nil )
        }
        
    }

    
    
}