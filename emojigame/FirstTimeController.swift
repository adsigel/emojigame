//
//  FirstTimeController.swift
//  emojigame
//
//  Created by Adam Sigel on 8/24/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit

class FirstTimeController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    
    
    @IBAction func checkMarkButton(sender: AnyObject) {
        performSegueWithIdentifier("tryOne", sender: sender)
    }
    
    
}