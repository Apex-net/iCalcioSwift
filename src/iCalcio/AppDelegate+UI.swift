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
        //self.window?.tintColor = UIColor.whiteColor()
        self.window?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
        // status bar style is lightContent by default
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // UITabBar appearence
        UITabBar.appearance().barStyle = UIBarStyle.Black
        // set the selected icon color
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        // set the text color for selected state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        
        // UIToolbar appearence
        UIToolbar.appearance().barStyle = UIBarStyle.Black
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        
        // UINavigationBar appearence
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // UIBarButtonItem appearence
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
    }
    
}
