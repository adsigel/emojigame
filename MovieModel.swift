//
//  MovieModel.swift
//  emojigame
//
//  Created by Adam Sigel on 7/19/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation

class MovieModel: NSObject {
    
    //properties
    
    var plot: String?
    var title: String?
    var value: Int?
    var hint: String?
    var created_by: Int?
    var movie_id: Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(plot: String, title: String, value: Int, hint: String) {
        
        self.plot = plot
        self.title = title
        self.value = value
        self.hint = hint
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Plot: \(plot), Title: \(title), Value: \(value), Hint: \(hint)"
        
    }
    
    
}