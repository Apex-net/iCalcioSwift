//
//  Player.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 30/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class Player {

    let name: String

    let picture: String?
    let link: String?
    let description: String?
    
    let born: String?
    let weight: String?
    let goals: String?
    let team: String?
    
    init(attributes: AnyObject) {
        
        self.name = attributes.valueForKeyPath("name") as! String

        self.picture = attributes.valueForKeyPath("picture") as? String
        self.link = attributes.valueForKeyPath("link") as? String
        self.description = attributes.valueForKeyPath("description") as? String
        
        self.born = attributes.valueForKeyPath("born") as? String
        self.weight = attributes.valueForKeyPath("weight") as? String
        self.goals = attributes.valueForKeyPath("goals") as? String
        self.team = attributes.valueForKeyPath("team") as? String
        
    }
    
}