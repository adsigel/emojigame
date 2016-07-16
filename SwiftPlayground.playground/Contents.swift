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
print("\("User has guessed " + count + "times.")")