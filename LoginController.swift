//
//  LoginController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/10/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//
//  TODO
//  * Use user.uid to get child values (e.g. score) for currentUser
//  * Email verification
//  * Confirm sign out
//  * Confirm new user added to db every time
//  * Intro screen

import UIKit
import Foundation
import TwitterKit
import Firebase
import GameKit

var userDict = [String:AnyObject]()
var uzer = ""
let userRef = ref.child("users")
var newUser = String()


class LoginController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeTextLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        uzer = UIDevice.currentDevice().identifierForVendor!.UUIDString
        print("sup uzer \(uzer)")
        let newUserRef = userRef.child(uzer)
        let dummyDict = ["dummy": "dummy"]
        newUserRef.setValue(dummyDict)
    }
    
    @IBAction func playButton(sender: AnyObject) {
        let newUserRef = userRef.child(uzer)
        newUserRef.observeEventType(.Value, withBlock: { (snapshot) in
            userDict = snapshot.value as! [String : AnyObject]
            print("userDict is \(userDict)")
        })
        if let new = userDict["new_in_town"] {
            newUser = userDict["new_in_town"] as! String
        } else {
            newUser = "nope"
        }
//        if let correct = userDict["correct"] {
//            correctCount = userDict["correct"]! as! Int
//        } else {
//            correctCount = 0
//        }
        self.currentDate()
        print("Is this a new user? \(newUser)")
        if newUser == "false" {
            // user has been here before
            print("This user has been here before.")
            performSegueWithIdentifier("logIn", sender: sender)
        } else {
            userDict = ["name": "", "email": "", "score": 0, "correct": 0, "addedDate": dateString, "exclude": ["key": true], "new_in_town": "true"]
            print("userDict is \(userDict)")
            newUserRef.setValue(userDict)
            performSegueWithIdentifier("firstTime", sender: sender)
        }
        
    }

    
    func currentDate() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        dateString = dateformatter.stringFromDate(NSDate())
    }

    func currentUser(uzer:String) {
        print("Current user device has id \(uzer)")
        let currentUserRef = ref.child("users")
        print("currentUserRef is \(currentUserRef)")
        currentUserRef.observeEventType(.Value, withBlock: { (snapshot) in
            userDict = snapshot.value as! [String : AnyObject]
            print("userDict is \(userDict)")
        })
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}