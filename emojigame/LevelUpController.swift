//
//  LevelUpController.swift
//  emojigame
//
//  Created by Adam Sigel on 7/23/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit

class LevelUpController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn: UIButton = UIButton(frame: CGRectMake(100, 400, 100, 50))
        btn.backgroundColor = UIColor.greenColor()
        btn.setTitle("Click Me", forState: UIControlState.Normal)
        btn.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = 1               // change tag property
        self.view.addSubview(btn) // add to view as subview
    }


    @IBAction func dismissNewLevel(sender: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
        print("User has acknowledged new level.")
    }
    
    func buttonAction(sender: UIButton!) {
        var btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            self.navigationController!.popViewControllerAnimated(true)
            print("User has acknowledged new level.")
        }
    }
    
}