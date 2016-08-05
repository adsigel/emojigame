//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var country = "United States"
var state = "Massachusetts"

// String Interpolation

let interpolatedAddress = "\(state + " " + country)"

let name = "Adam"
let greeting = "\("Hi there, " + name + ".")"

let count = 4

let dateString = NSDate()

dateString

let movieIDArray = ["-KOKKRYrOIpIHG07nD7b", "-KOKKbVx3USwh3u9C3Pa", "-KOKKv9N7J1VzkhGNBoZ", "-KOKKzDwsUan1RE6xS5Z", "-KOKT906d3EZWEB8YS4p", "-KOKh-mYuHbjtjpql7AI", "-KOKhLGpxOpNJV47Wl_Q", "-KOM4N4B5QyDorBlsmf4", "-KOM9bRcvfafiNsmAI1y", "-KOPVq4DmzLhwqmP_J8K"]

var randomNumber = Int(arc4random_uniform(UInt32(movieIDArray.count)))

var movieToGuess = movieIDArray[randomNumber]


