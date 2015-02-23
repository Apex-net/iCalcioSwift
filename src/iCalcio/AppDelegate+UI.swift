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
        
        // init app colors
        let appMainTintColor :UIColor = self.mainTintColor
        let appBarTintColor :UIColor = self.barTintColor
        let appTitleTextColor :UIColor = self.mainTintColor

        // Window Settings
        self.window?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
        // status bar style is lightContent by default
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // UITabBar appearence
        //UITabBar.appearance().barStyle = UIBarStyle.Black
        // set the selected icon color
        UITabBar.appearance().barTintColor = appBarTintColor // set color for tabbar
        UITabBar.appearance().tintColor = appMainTintColor //UIColor.whiteColor()
        // set the text color for selected state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : appTitleTextColor], forState: UIControlState.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : appTitleTextColor], forState: UIControlState.Normal)
        
        // UIToolbar appearence
        UIToolbar.appearance().barStyle = UIBarStyle.Black
        UIToolbar.appearance().tintColor = appMainTintColor //UIColor.whiteColor()
        
        // UINavigationBar appearence
        UINavigationBar.appearance().barTintColor = appBarTintColor //UIColor.blackColor()
        UINavigationBar.appearance().tintColor = appMainTintColor //UIColor.whiteColor()
        UINavigationBar.appearance().tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : appTitleTextColor]
        
        // UIBarButtonItem appearence
        UIBarButtonItem.appearance().tintColor = appMainTintColor //UIColor.whiteColor()
        
    }
    
    var mainTintColor : UIColor{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let keyValue : AnyObject? = dict?.valueForKey("AppMainTintColor")
        var stringNative :String = String()
        var outMainTintColor :UIColor = UIColor.whiteColor()
        if let nsString:NSString = keyValue as? NSString{
            stringNative = nsString as String
            outMainTintColor = UIColor(arithmeticNotation: stringNative)
        }
        return outMainTintColor;
    }
    
    var barTintColor : UIColor{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let keyValue : AnyObject? = dict?.valueForKey("AppBarTintColor")
        var stringNative :String = String()
        var outBarTintColor :UIColor = UIColor.blackColor()
        if let nsString:NSString = keyValue as? NSString{
            stringNative = nsString as String
            outBarTintColor = UIColor(arithmeticNotation: stringNative)
        }
        return outBarTintColor;
    }
    
}
