//
//  Plots.swift
//  emojigame
//
//  Created by Adam Sigel on 7/7/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation

struct PlotList {
    
    let plotArray = [
        "💣🚌",
        "💾🚤🔫😶💻🆗",
        "👮🏻👱🏿🚌🔥💤🐚🐚🐚👮🏻👱🏿🔫☮️",
        "👱🚿👩🔪👣",
        "🏠👩📺💥🌀💡🔆💡👵🛀👩👿💫🌀💡💥🚫🚘🏥",
        "👩🔭🌌🚙💥💪🌀👑🔨❄️😏😡🚫🔨☕️💑",
        "🇯🇵😴➡️😴💰✈️😴😴😴➡️😴➡️😴☔️🚄🚓☔️😴🔫➡️😴❄️😴🔫🏢🔙😴➡️👫😳"
        ]
    
    let titleArray = [
        "speed",
        "the net",
        "demolition man",
        "psycho",
        "poltergeist",
        "thor",
        "inception"
    ]

    var userGuess: String = "nil"
    
    func randomMovie () -> Array<String> {
        var randomNumber = Int(arc4random_uniform(UInt32(plotArray.count)))
        var secretTitle = titleArray[randomNumber]
        var answerArray = [plotArray[randomNumber], titleArray[randomNumber]]
        return answerArray
    }
    
    
}

func input() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
}