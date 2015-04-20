//
//  AppDelegate+GoogleAnalytics.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 17/10/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

extension AppDelegate
    {
    
    // MARK: GoogleAnalytics tracking
    
    func initGoogleAnalytics() {

        // Init Google Analytics Tracker
        let GAAccountID = self.appGAAccountID
        //println("GAAccountID: \(GAAccountID)")
        let defaultGANDispatchPeriodSec :NSTimeInterval = 10
        GAI.sharedInstance().dispatchInterval = defaultGANDispatchPeriodSec
        GAI.sharedInstance().trackUncaughtExceptions = true
        #if DEBUG
            GAI.sharedInstance().logger.logLevel = GAILogLevel.Error
        #endif
        var tracker = GAI.sharedInstance().trackerWithTrackingId(GAAccountID)
        // Track event for the App Load
        let label = "\(self.teamName) - \(self.appVersion)"
        let category = "New app with Swift code"
        let action = "app_loaded"
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: -1).build()  as [NSObject : AnyObject])
        
    }
    
    func stopGoogleAnalytics() {
        // stop Google Analytics Tracker
        var tracker = GAI.sharedInstance().defaultTracker
        GAI.sharedInstance().removeTrackerByName(tracker.name)
    }
    
    func trackScreen(screenName: String) {
        // Manually send a screen view for tracking
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screenName)
        var build = GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject]
        tracker.send(build)
        
        
    }
    
}
