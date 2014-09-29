//
//  Match.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 26/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class Match {
    
    let date: String
    let hour: String
    let description: String
    let result: String
    
    let leg: String?
    let latitude: String?
    let longitude: String?
    let stadiumName: String?
    
    init(attributes: AnyObject) {
        
        self.date = attributes.valueForKeyPath("date") as String
        self.hour = attributes.valueForKeyPath("hour") as String
        self.description = attributes.valueForKeyPath("description") as String
        self.result = attributes.valueForKeyPath("result") as String
        
        self.leg = attributes.valueForKeyPath("leg") as? String
        self.latitude = attributes.valueForKeyPath("latitude") as? String
        self.longitude = attributes.valueForKeyPath("longitude") as? String
        self.stadiumName = attributes.valueForKeyPath("stadium_name") as? String
        
    }
    
}