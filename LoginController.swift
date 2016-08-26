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
//        authenticateLocalPlayer()
        uzer = UIDevice.currentDevice().identifierForVendor!.UUIDString
        print("sup uzer \(uzer)")
        let dummyDict = ["dummy": "dummy"]
        let newUserRef = userRef.child(uzer)
        newUserRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            print(snapshot.value!)
            if snapshot.value is NSNull {
                print("This snapshot is null. This is a new UDID.")
                newUser = "true"
                newUserRef.setValue(dummyDict)
            } else {
                print("There is a snapshot. A user with this UDID has been here before.")
                newUser = "false"
            }
        })
    }
    
    @IBAction func playButton(sender: AnyObject) {
        let newUserRef = userRef.child(uzer)
        self.currentDate()
        print("Is this a new user? \(newUser)")
        if newUser == "false" {
            // user has been here before
            print("This user has been here before.")
            newUserRef.observeEventType(.Value, withBlock: { (snapshot) in
                userDict = snapshot.value! as! [String : AnyObject]
                print("userDict is \(userDict)")
            })
            delay(1.0) {
                self.performSegueWithIdentifier("logIn", sender: sender)
            }
        } else {
            userDict = ["name": "", "email": "", "score": 0, "correct": 0, "addedDate": dateString, "exclude": ["key": true], "new_in_town": "true"]
            print("userDict is \(userDict)")
            newUserRef.setValue(userDict)
            delay(1.0) {
                self.performSegueWithIdentifier("firstTime", sender: sender)
            }
        }
        
    }

    
    func currentDate() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        dateString = dateformatter.stringFromDate(NSDate())
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func authenticateLocalPlayer(){
        var localPlayer = GKLocalPlayer.localPlayer()
        print("localPlayer is: \(localPlayer)")
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
}