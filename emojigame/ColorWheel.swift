//
//  ColorWheel.swift
//  Fun Facts
//
//  Created by Adam Sigel on 7/8/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit

struct ColorWheel {
    
    let colorsArray = [
        UIColor(red: 200/255.0, green: 100/255.0, blue: 12/255.0, alpha: 1.0),
        UIColor(red: 180/255.0, green: 175/255.0, blue: 253/255.0, alpha: 1.0),
        UIColor(red: 20/255.0, green: 68/255.0, blue: 123/255.0, alpha: 1.0),
        UIColor(red: 38/255.0, green: 210/255.0, blue: 112/255.0, alpha: 1.0),
    ]
    
    func randomColor() -> UIColor {
        let randomNumber = Int(arc4random_uniform(UInt32(colorsArray.count)))
        return colorsArray[randomNumber]
    }
}
