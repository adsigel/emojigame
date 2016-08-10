//
//  LoginController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/10/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import UIKit
import Foundation
import TwitterKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in with userID \(unwrappedSession.userID)",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                let authToken = session!.authToken
                let authTokenSecret = session!.authTokenSecret
                let authID = session!.userID
                let authName = session!.userName
                self.currentDate()
                print("authToken is \(authToken)")
                print("authTokenSecret is \(authTokenSecret)")
                let credential = FIRTwitterAuthProvider.credentialWithToken(session!.authToken, secret: session!.authTokenSecret)
                let userData = User(uid: authID as! Int, email: "", displayName: "", twitterName: authName, score: userScoreValue, addedDate: dateString)
                let userRef = ref.child("users/" + authID)
                userRef.setValue(userData.toAnyObjectUser())
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
//    
//    @IBAction func signOut(sender: AnyObject) {
//        let firebaseAuth = FIRAuth.auth()
//        do {
//            try firebaseAuth?.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
    
    
    @IBAction func signUpButton(sender: AnyObject) {
        let email = emailTextField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                if error == nil {
                    // Log user in
                    let uid = userRef.key
                    FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
                        let userData = User(uid: 01 as! Int, email: "", displayName: "", twitterName: "", score: userScoreValue, addedDate: dateString)
                        let userRef = ref.child("users/")
                        let userNew = userRef.childByAutoId()
                        userRef.setValue(userData.toAnyObjectUser())
                        let uid = userRef.key
                    }
                } else {
                    // Handle errors here
                }
            }

    }
    
    
    @IBAction func logInButton(sender: AnyObject) {
    
    
    }
   
    
    
    func currentDate() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        dateString = dateformatter.stringFromDate(NSDate())
    }

    
}