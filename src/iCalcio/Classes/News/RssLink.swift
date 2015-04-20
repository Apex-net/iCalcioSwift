//
//  RssLink.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 22/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class RssLink{
    let link: String
    
    init(attributes: AnyObject) {
        self.link = attributes.valueForKeyPath("link") as! String
    }
    
}
