//
//  Ranking.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 01/10/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class Ranking{
    let description: String
    let points: String

    let games: String?
    let wins: String?
    let ties: String?
    let defeats: String?
    
    init(attributes: AnyObject) {
        self.description = attributes.valueForKeyPath("description") as! String
        self.points = attributes.valueForKeyPath("point") as! String

        self.games = attributes.valueForKeyPath("play") as? String
        self.wins = attributes.valueForKeyPath("wins") as? String
        self.ties = attributes.valueForKeyPath("ties") as? String
        self.defeats = attributes.valueForKeyPath("defeats") as? String
    }
    
}