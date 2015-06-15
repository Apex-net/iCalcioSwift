//
//  YoutubeVideo.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 16/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

class YoutubeVideo{

    let idVideo: String

    let title: String
    let description: String?
    
    let updated: String
    
    let thumbnailURLString: String
    
    init(attributes: AnyObject) {

        // [!] todo
        // id.videoId (yes) or id.playlistId (no)
        self.idVideo = attributes.valueForKeyPath("id.videoId") as! String
        
        self.title = attributes.valueForKeyPath("snippet.title") as! String
        
        self.description = attributes.valueForKeyPath("snippet.description") as? String
        
        self.updated = attributes.valueForKeyPath("snippet.publishedAt") as! String
        
        self.thumbnailURLString = attributes.valueForKeyPath("snippet.thumbnails.default.url") as! String
        
    }
    
}