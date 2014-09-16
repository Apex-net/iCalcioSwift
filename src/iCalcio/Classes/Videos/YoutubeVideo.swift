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
    let category: String?
    let likeCount: String?
    
    let rating: Double?
    let viewCount: Double?
    
    let updated: String // todo: trasform to date
    
    let thumbnailURLString: String
    let videoURLString: String
    
    init(attributes: AnyObject) {

        self.idVideo = attributes.valueForKeyPath("id") as String
        self.title = attributes.valueForKeyPath("title") as String
        
        self.description = attributes.valueForKeyPath("description") as? String
        self.category = attributes.valueForKeyPath("category") as? String
        self.likeCount = attributes.valueForKeyPath("likeCount") as? String
        
        self.rating = attributes.valueForKeyPath("rating") as? Double
        self.viewCount = attributes.valueForKeyPath("viewCount") as? Double
        
        // todo: dateformatter???
        self.updated = attributes.valueForKeyPath("updated") as String
        
        self.thumbnailURLString = attributes.valueForKeyPath("thumbnail.sqDefault") as String
        self.videoURLString = attributes.valueForKeyPath("player.default") as String
        
    }
    
}