//
//  AppDelegate+UI.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 17/10/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

extension AppDelegate
    {
    
    // MARK: UI settings
    func customizeAppearance() {

        // Window Settings
        self.window?.tintColor = UIColor.whiteColor()
        self.window?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
        // status bar style is lightContent by default
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // UITabBar and UIToolbar appearence
        UITabBar.appearance().barStyle = UIBarStyle.Black
        UIToolbar.appearance().barStyle = UIBarStyle.Black
        
        // UINavigationBar appearence
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

    }
    
}
