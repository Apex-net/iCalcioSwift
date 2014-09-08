//
//  AppDelegate+Settings.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 08/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

extension AppDelegate
{
    var appName : String
        {
            let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject = dict.valueForKey("CFBundleDisplayName")!
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
        }
    
    var apiBaseUrl : String
        {
            let path = NSBundle.mainBundle().pathForResource("Urls", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject = dict.valueForKey("ANBaseUrl")!
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            let pathInfo = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dictInfo = NSDictionary(contentsOfFile: pathInfo!)
            let keyValueInfo : AnyObject = dictInfo.valueForKey("ANUrlTeamName")!
            var stringNativeInfo :String = String()
            if let nsStringInfo:NSString = keyValueInfo as? NSString{
                stringNativeInfo = nsStringInfo as String
            }
                
            return stringNative + "/" + stringNativeInfo;
    }

    var teamName : String
        {
            let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject = dict.valueForKey("ANTeamName")!
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }
    

}