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

var userDict = [String:AnyObject]()
var userID : String = ""
var loggedIn = false

class LoginController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeTextLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkForUserInitial() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // user is signed in
                print("A user exists.")
                loggedIn = true
                print("loggedIn = \(loggedIn)")
                uid = user.uid
                print("Fetching user data from user child path \(uid)")
                self.currentUser(uid)
                print("Here is userDict: \(userDict)")
            } else {
                //no user is signed in
                loggedIn = false
                print("loggedIn = \(loggedIn)")
                
            }
        }
    }

    
    func currentDate() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        dateString = dateformatter.stringFromDate(NSDate())
    }

    func currentUser(uid:String) {
        print("Current user is signed in with uid \(uid)")
        let currentUserRef = userRef.ref.child(uid)
        print("currentUserRef is \(currentUserRef)")
        currentUserRef.observeEventType(.Value, withBlock: { (snapshot) in
            userDict = snapshot.value as! [String : AnyObject]
            print("userDict is \(userDict)")
        })
    }
    
    func addNewUser() {
        self.currentDate()
        let userData = User(uid: userDict["uid"]! as! String, email: userDict["email"]! as! String, displayName: userDict["name"]! as! String, score: 0, addedDate: dateString)
        let userRef = ref.child("users/")
        let newUser = userRef.child(uid)
        // TODO: MAKE SURE NEW CHILD NODE ADDED FOR NEW USER
        newUser.setValue(userData.toAnyObjectUser())
        newUser.child("exclude").child("key").setValue(true)
        print("New user added with uid of \(uid) and email \(userDict["email"])")
    }
    
    @IBAction func checkUserEmail(sender: AnyObject) {
        if let user = FIRAuth.auth()?.currentUser {
            let email = user.email
        } else {
            // No user is signed in.
        }
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let email = emailTextField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                if error == nil {
                    // Log user in
                    uid = user!.uid
                    print("uid is \(uid)")
                    var name = ""
                    if user!.displayName != nil {
                        name = user!.displayName!
                    } else {
                        name = ""
                    }
                    let email = user!.email!
                    userDict = ["uid": uid, "name": name, "email": email, "score": 0, "exclude": ["key": true]]
                    self.addNewUser()
                    FIRAuth.auth()?.signInWithEmail(email, password: password!) { (user, error) in
                    }
                } else {
                    // Handle errors here
                }
            }
        performSegueWithIdentifier("signUp", sender: sender)
    }
    
    
    @IBAction func logInButton(sender: AnyObject) {
        if self.emailTextField.text == "" {
            print("No email entered.")
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( CATransform3D:CATransform3DMakeTranslation(-10, 0, 0 ) ),
                NSValue( CATransform3D:CATransform3DMakeTranslation( 10, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            self.emailTextField.layer.addAnimation( anim, forKey:nil )
            self.welcomeTextLabel.hidden = false
            self.welcomeTextLabel.text = "Who dis?"
        } else
            if self.passwordTextField.text == "" {
            print("No password entered.")
            let anim = CAKeyframeAnimation( keyPath:"transform" )
            anim.values = [
                NSValue( CATransform3D:CATransform3DMakeTranslation(-10, 0, 0 ) ),
                NSValue( CATransform3D:CATransform3DMakeTranslation( 10, 0, 0 ) )
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 7/100
            
            self.passwordTextField.layer.addAnimation( anim, forKey:nil )
            self.welcomeTextLabel.hidden = false
            self.welcomeTextLabel.text = "Oops, no password!"
        } else {
            print("Attempting to sign in...")
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    loggedIn = true
                    print("loggedIn = \(loggedIn)")
                    uid = user.uid
                    print("Fetching user data from user child path \(uid)")
                    self.currentUser(uid)
                    self.performSegueWithIdentifier("logIn", sender: sender)
                } else {
                    //no user is signed in
                    loggedIn = false
                    print("loggedIn = \(loggedIn)")
                    print("User not logged in.")
                    let invalidUserAlert = UIAlertController(title: "Something's gone wrong", message: "Please try again. If you don't remember your password, we can reset it for you.", preferredStyle: UIAlertControllerStyle.Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        
                    }
                    let PasswordAction = UIAlertAction(title: "Reset password", style: .Cancel) { (action)
                        in
                        let email = self.emailTextField.text
                        FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
                            if let error = error {
                                // An error happened.
                            } else {
                                // Password reset email sent.
                                print("Password reset email sent.")
                            }
                        }
                    }
                    invalidUserAlert.addAction(OKAction)
                    invalidUserAlert.addAction(PasswordAction)
                    self.presentViewController(invalidUserAlert, animated: true, completion: nil)
                    }
            }
        }
    }
}