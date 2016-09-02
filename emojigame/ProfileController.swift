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
import GameKit
import Mixpanel

var gcScore : Int = 0

class ProfileController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var submittedLabel: UILabel!
    @IBOutlet weak var trophyPersistence: UIButton!
    @IBOutlet weak var trophyFirst: UIButton!
    @IBOutlet weak var trophyCrayon: UIButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        print("Loading CreateProfile page.")
        print("userDict is \(userDict)")
        self.correctLabel.text = String(userDict["correct"]!)
        self.nameField.text = String(userDict["name"]!)
        self.emailField.text = String(userDict["email"]!)
        getSubmittedCount()
        getTrophies()
    }
    
    
    @IBAction func finishUpButton(sender: AnyObject) {
        let name = nameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let email = emailField.text?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let userRef = ref.child("users").child(uzer)
        userRef.child("name").setValue(name)
        userRef.child("email").setValue(email)
        performSegueWithIdentifier("backToGame", sender: sender)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func followTwitter(sender: AnyObject) {
        let url = NSURL(string: "https://twitter.com/emojisodes")!
        UIApplication.sharedApplication().openURL(url)
        Mixpanel.mainInstance().track(event: "View Twitter profile")
    }
    
    @IBAction func sendPraise(sender: AnyObject) {
        let url = NSURL(string: "https://itunes.apple.com/us/app/emojisodes/id1147295394?ls=1&mt=8")!
        UIApplication.sharedApplication().openURL(url)
        Mixpanel.mainInstance().track(event: "Link to App Store")
    }
    
    @IBAction func showLeaderboard(sender: AnyObject) {
        saveHighscore(gcScore)
        showLeader()
    }
    
    func getTrophies() {
        if userDict["persistence"] != nil {
            let persistence = userDict["persistence"] as! Bool
            if persistence == true {
                self.trophyPersistence.setTitle("🏋", forState: UIControlState.Normal)
            }
        }
        let exclude = userDict["exclude"] as! NSDictionary
        let excludeString = exclude.description
        if excludeString.rangeOfString("correct") != nil {
            self.trophyFirst.setTitle("🚼", forState: UIControlState.Normal)
        }
        if userDict["submitted"] != nil {
            self.trophyCrayon.setTitle("🖍", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func persistence(sender: AnyObject) {
        if self.trophyPersistence.titleLabel!.text == "🏋" {
            let trophy = UIAlertController(title: "Persistence", message: "You got a movie right after more than 5 guesses!", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Awesome", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        } else {
            let trophy = UIAlertController(title: "🔒", message: "???", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Harumph", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        }
    }
    
    @IBAction func firstSolve(sender: AnyObject) {
        if self.trophyFirst.titleLabel!.text == "🚼" {
            let trophy = UIAlertController(title: "Learning to Crawl", message: "You solved your first movie!", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Awesome", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        } else {
            let trophy = UIAlertController(title: "🔒", message: "???", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Harumph", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        }
    }

    @IBAction func crayon(sender: AnyObject) {
        if self.trophyCrayon.titleLabel!.text == "🖍" {
            let trophy = UIAlertController(title: "Author, Author", message: "You submitted your first movie to Emojisodes!", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Awesome", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        } else {
            let trophy = UIAlertController(title: "🔒", message: "???", preferredStyle: UIAlertControllerStyle.Alert)
            trophy.addAction(UIAlertAction(title: "Harumph", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction!) in
                trophy.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(trophy, animated: true, completion: nil)
        }
    }
    
    
    func getSubmittedCount() {
        userRef.child(uzer).child("submitted").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            var count = 0
            count += Int(snapshot.childrenCount)
            print("count of child nodes is \(count)")
            self.submittedLabel.text = String(count)
        })
    }
    
    func saveHighscore(gcScore:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "grp.emojisodes")
            var gcScore = userDict["score"]! as! Int
            print("gcScore is \(gcScore)")
            scoreReporter.value = Int64(gcScore)
            var scoreArray: [GKScore] = [scoreReporter]
            print("scoreArray is \(scoreArray)")
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(NSError) -> Void in
                if NSError != nil {
                    print(NSError!.localizedDescription)
                } else {
                    print("completed Easy")
                }
            })
        }
    }
    
    func showLeader() {
        var vc = self
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc.presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }



    
}
