//: Playground - noun: a place where people can play

import UIKit


var allMovies = ["a", "b", "c", "d", "e", "f", "g"]
var playedMovies = ["a", "b", "c"]
var count = allMovies.count
var selected = ""

    repeat {
        var random = Int(arc4random_uniform(UInt32(allMovies.count)))
        selected = allMovies[random]
    } while playedMovies.contains(selected)
    selected = allMovies[random]
    print(selected)

//
//moviePlayedKeys.contains("movie1")
//randomIndex = Int(arc4random_uniform(UInt32(movieCount)))
 // Check to see if user has played that movie before
//repeat {
//    randomIndex = Int(arc4random_uniform(UInt32(movieCount)))
//    movieToGuess = moviePlayedKey[randomIndex]
//    print("movieToGuess is \(movieToGuess)")
//} while !contains(moviePlayed, movieToGuess)


//movieToGuess = movieIDArray[randomIndex]
//if moviePlayedKeys.count == movieCount {
//    moviePlayedKeys = []
//}
//

