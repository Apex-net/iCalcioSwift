//
//  TeamInfo.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 29/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class TeamInfo {
    
    var legDate: NSDate?
    
    let version: String

    let stadiumLatitude: String?
    let stadiumLongitude: String?
    let stadiumName: String?
    
    init(attributes: AnyObject) {
        
        let dateString = attributes.valueForKeyPath("dat_ritorno") as? String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        if let ds = dateString {
            var date = dateFormatter.dateFromString(ds)
            self.legDate = date
        }
        
        self.version = attributes.valueForKeyPath("version") as! String
        
        self.stadiumLatitude = attributes.valueForKeyPath("stadium_latitude") as? String
        self.stadiumLongitude = attributes.valueForKeyPath("stadium_longitude") as? String
        self.stadiumName = attributes.valueForKeyPath("stadium_name") as? String
        
    }
    
}