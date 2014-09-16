//
//  YoutubeChannel.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 16/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class YoutubeChannel{
    let title: String
    let subTitle: String
    let channel: String
    
    init(attributes: AnyObject) {
        self.title = attributes.valueForKeyPath("title") as String
        self.subTitle = attributes.valueForKeyPath("subtitle") as String
        self.channel = attributes.valueForKeyPath("channel") as String
    }
    
}