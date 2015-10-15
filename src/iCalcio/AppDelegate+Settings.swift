//
//  AppDelegate+Settings.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 08/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation
import Alamofire

extension AppDelegate
{

    var appName : String{
            let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("CFBundleDisplayName")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }
    
    var appVersion : String{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("CFBundleVersion")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }
    
    var appAppleStoreURL : String{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("AppStoreURL")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }

    var appFacebookURL : String{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let keyValue : AnyObject? = dict?.valueForKey("AppFacebookURL")
        var stringNative :String = String()
        if let nsString:NSString = keyValue as? NSString{
            stringNative = nsString as String
        }
        return stringNative;
    }

    var apiBaseUrl : String{
            let path = NSBundle.mainBundle().pathForResource("Urls", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("ANBaseUrl")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            let pathInfo = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dictInfo = NSDictionary(contentsOfFile: pathInfo!)
            let keyValueInfo : AnyObject? = dictInfo?.valueForKey("ANUrlTeamName")
            var stringNativeInfo :String = String()
            if let nsStringInfo:NSString = keyValueInfo as? NSString{
                stringNativeInfo = nsStringInfo as String
            }
                
            return stringNative + "/" + stringNativeInfo;
    }

    var apnsBaseUrl : String{
        let path = NSBundle.mainBundle().pathForResource("Urls", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("ANApnsBaseUrl")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            
            return stringNative;
    }
    
    var teamName : String{
            let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("ANTeamName")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }
    
    var youtubeBaseUrl : String {
        let stringNative: String = "https://www.googleapis.com/youtube/v3"
                
        return stringNative
    }
    
    var appYoutubeID : String{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let keyValue : AnyObject? = dict?.valueForKey("AppYoutubeID")
        var stringNative :String = String()
        if let nsString:NSString = keyValue as? NSString{
            stringNative = nsString as String
        }
        return stringNative;
    }
    
    func getTeamInfo() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/GeneralInfo.txt"
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        //print("Success with JSON: \(JSON)")
                        if let JsonArray:AnyObject = JSON.valueForKeyPath("data"), parsedTeamInfomations = JsonArray as? [AnyObject] {
                            self.teamInfomations = parsedTeamInfomations.map({ obj in TeamInfo(attributes: obj) })
                        }
                    }
                } else {
                    print("Request failed with error: \(response.result.error)")
                    if let dataFailure = response.data {
                        print("Response data: \(NSString(data: dataFailure, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
    }
    
    var teamInformation : TeamInfo? {
        
        var teamInfo : TeamInfo?
        if self.teamInfomations.count == 1 {
            teamInfo = self.teamInfomations[0]
        }
        return teamInfo
    }
    
    var appGAAccountID : String{
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let keyValue : AnyObject? = dict?.valueForKey("AppGAAccountID")
            var stringNative :String = String()
            if let nsString:NSString = keyValue as? NSString{
                stringNative = nsString as String
            }
            return stringNative;
    }

}