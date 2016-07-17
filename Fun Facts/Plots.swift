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
        "🚍💣",
        "💾🚤🔫😶💻🆗",
        "👮🏻👱🏿🚌🔥💤🐚🐚🐚👮🏻👱🏿🔫☮️",
        "👱🚿👩🔪👣",
        "🏠👩📺💥🌀💡🔆💡👵🛀👩👿💫🌀💡💥🚫🚘🏥",
        "👩🔭🌌🚙💥💪🌀👑🔨❄️😏😡🚫🔨☕️💑",
        "🇯🇵😴➡️😴💰✈️😴😴😴➡️😴➡️😴☔️🚄🚓☔️😴🔫➡️😴❄️😴🔫🏢🔙😴➡️👫😳",
        "🇲🇽🌵⛪️😄😀😃🐎🎤😚🌳🎤🔥🏕👀✈️🐎🎉🎂👨🔫🔫🔫💃",
        "👦🏢😐😬😏📝📚🎧🔨🔦💩😅💰👴🔫⛵️🌅",
        "😰😩😉🚗🙋🏙🍸🎨⚾️🎤🎉🚗💥👟😎",
        "⏰⏰🎸😀👴⏱🚙⌛️⏳😀👦🚙💩🎸😘🌩⏳⌛️😊",
        "👦👧💻📚🌹💞",
        "👦🖥🎠👳💤👨🌠🎹🤖👨‍❤️‍💋‍👨🎮👳👦",
        "✋🎠🔫👼💣👨🔀👨🔫🚤🔫👨🔀👨👦✋",
        "😀🔍🐶🚙🏈🐬⁉️👩🔀👨😖🐬🔍😉",
        "😠💪🚔➡️🎓👨👔👿💥🚙",
        "🌏🤖🌱😍🚀🌌💑🌎"
        ]
    
    let titleArray = [
        "speed",
        "the net",
        "demolition man",
        "psycho",
        "poltergeist",
        "thor",
        "inception",
        "the three amigos",
        "the shawshank redemption",
        "ferris bueller's day off",
        "back to the future",
        "you've got mail",
        "big",
        "face off",
        "ace ventura",
        "kindergarten cop",
        "wall-e"
    ]
    
    let hintArray = [
        "'Yeah, but I'm taller.'",
        "'Just give us the disk and we'll give you your life back.'",
        "'Teddy bear.'",
        "Directed by Alfred Hitchcock",
        "Written by Steven Spielberg, released in 1982",
        "The first emoji represents Natalie Portman",
        "'You've got to dream a little bigger darling.'",
        "'It's a sweater!'",
        "The last emoji represents Zihuatanejo",
        "'Pardon my French, but you're an asshole!'",
        "'1.21 gigawatts!'",
        "'Don't cry, Shopgirl.'",
        "'...Shimmy shimmy, cocoa pop. Shimmy shimmy rock...'",
        "Released in 1997, directed by John Woo",
        "'Alrighty then!'",
        "'It's not a tumor!'",
        "39 minutes pass before the first spoken dialog"
    ]
    
    let scoreArray = [
        "10",
        "50",
        "30",
        "15",
        "50",
        "30",
        "25",
        "35",
        "20",
        "25",
        "15",
        "30",
        "25",
        "50",
        "15",
        "50",
        "15"
    ]

    var userGuess: String = "nil"
    
    func randomMovie () -> Array<String> {
        var randomNumber = Int(arc4random_uniform(UInt32(plotArray.count)))
        var secretTitle = titleArray[randomNumber]
        var answerArray = [plotArray[randomNumber], titleArray[randomNumber], hintArray[randomNumber], scoreArray[randomNumber]]
        return answerArray
    }
    
    
}

func input() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
}