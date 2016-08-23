//
//  CreateProfile.swift
//  emojigame
//
//  Created by Adam Sigel on 8/22/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class CreateProfileController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var finishUpButtonText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading CreateProfile page.")
        print("userDict is \(userDict)")
    }


    @IBAction func finishUpButton(sender: AnyObject) {
        let name = userNameTextField.text
        print("Current user is signed in with uid \(uid)")
        let currentUserRef = userRef.ref.child(uid)
        print("currentUserRef is \(currentUserRef)")
        currentUserRef.child("displayName").setValue(name)
        // THE LINE BELOW IS NOT DECLARING CORRECTLY
        currentUserRef.child("exclude").child("key").setValue(true)
        performSegueWithIdentifier("finishUp", sender: sender)
    }


}
