//
//  WebLink.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 10/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class WebLink{
    let title: String
    let subTitle: String
    let link: String
    
    init(attributes: AnyObject) {
        self.title = attributes.valueForKeyPath("title") as String
        self.subTitle = attributes.valueForKeyPath("subtitle") as String
        self.link = attributes.valueForKeyPath("link") as String
    }
    
}
