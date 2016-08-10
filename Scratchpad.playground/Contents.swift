//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//Swift recap

var someVariable = "aVariable"
let someConstant = 20

someVariable = "anotherString"
//someConstant = 15

var fruitsArray = ["apples", "bananas", "kiwis"]
fruitsArray.append("strawberries")

fruitsArray

//Optional

var optionalString: String? = "hello"
optionalString = nil

fruitsArray[1]

//Random Number Generation

var randomNumber = Int(arc4random_uniform(10))

//UIColor

var redColor = UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0)


//Debug

let colorsArray = [
    UIColor(red: 200/255.0, green: 100/255.0, blue: 12/255.0, alpha: 1.0),
    UIColor(red: 180/255.0, green: 175/255.0, blue: 253/255.0, alpha: 1.0),
    UIColor(red: 20/255.0, green: 68/255.0, blue: 123/255.0, alpha: 1.0),
    UIColor(red: 38/255.0, green: 210/255.0, blue: 112/255.0, alpha: 1.0),
]

colorsArray.count
UInt32(colorsArray.count)
var randomInt = Int(arc4random_uniform(UInt32(colorsArray.count)))



//func randomColor() -> UIColor {
//    var unassignedArrayCount = UInt32(colorsArray.count)
//    var unassignedRandomNumber = arc4random_uniform(unassignedArrayCount)
//    var randomNumber = Int(unassignedRandomNumber)
//    return colorsArray[randomNumber]
//

struct movieStruct {
    let key: String!
    let title: String!
    let plot: String!
    let hint: String!
    let addedByUser: String!
    let addedDate: String!
    let points: Int!
    let approved: Bool!
    
}

var movie1 = movieStruct(
    key: "-KOKKRYrOIpIHG07nD7b",
    title: "the net",
    plot: "💾🚤🔫😶💻🆗",
    hint: "Just give us the disk and we'll give you your life back.",
    addedByUser: "adsigel@gmail.com",
    addedDate: "Thursday, August 4, 2016",
    points: 50,
    approved: true
)

var movie2 = movieStruct(key: "-KOKKbVx3USwh3u9C3Pa", title: "demolition man", plot: "👮🏻👱🏿🚌🔥💤🐚🐚🐚👮🏻👱🏿🔫☮️", hint: "👮🏻👱🏿🚌🔥💤🐚🐚🐚👮🏻👱🏿🔫☮️", addedByUser: "adsigel@gmail.com", addedDate: "Thursday, August 4, 2016", points: 100, approved: true)


print(movie1.plot)