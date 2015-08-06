//
//  ActivityViewCustom.swift
//  iComune
//
//  Created by Andrea Calisesi on 06/07/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import Foundation

class ActivityViewCustom: UIActivity {
    
    var customActivityType = ""
    var activityName = ""
    var activityImageName = ""
    var customActionWhenTapped:( (Void)-> Void)!
    
    init(title: String, imageName:String, performAction: (() -> ()) ) {
        self.activityName = title
        self.activityImageName = imageName
        self.customActivityType = "Action \(title)"
        self.customActionWhenTapped = performAction
        super.init()
    }
    
    override func activityType() -> String? {
        return customActivityType
    }
    
    override func activityTitle() -> String? {
        return activityName
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: activityImageName)
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        // nothing to prepare
    }
    
    override func activityViewController() -> UIViewController? {
        return nil
    }
    
    override func performActivity() {
        customActionWhenTapped()
    }
}