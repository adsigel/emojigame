//
//  FirstTimeController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/24/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit
import Mixpanel

class FirstTimeController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        Mixpanel.mainInstance().time(event: "Onboarding")
    }
    
    
    @IBAction func checkMarkButton(sender: AnyObject) {
        performSegueWithIdentifier("tryOne", sender: sender)
    }
    
    
}