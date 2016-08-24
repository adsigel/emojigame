//
//  ProfileController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/23/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ProfileController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading CreateProfile page.")
        print("userDict is \(userDict)")
    }
    
    
    @IBAction func finishUpButton(sender: AnyObject) {
        let name = nameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let email = emailField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userRef = ref.child("users").child(uzer)
        userRef.child("name").setValue(name)
        userRef.child("email").setValue(email)
        performSegueWithIdentifier("backToGame", sender: sender)
    }
    
    
}
