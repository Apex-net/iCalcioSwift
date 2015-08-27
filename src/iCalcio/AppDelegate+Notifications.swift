//
//  AppDelegate+Notifications.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 14/10/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation
import Alamofire

extension AppDelegate
{
    
    // MARK: Local notifications
    
    func initLocalNotifications(application: UIApplication) {
        
        // registering for sending user various kinds of notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],categories:nil))
        
    }
    
    func application(application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification) {
            // Called when the user taps on a local notification (without selecting
            // an action), or if a local notification arrives while using the app
            // (in which case the notification isn't shown to the user)
            
            //println("Received local notification \(notification.category)!")
            let state:UIApplicationState = application.applicationState
            // alert management for app in active state
            if (state == UIApplicationState.Active) && (notification.category == "EVENTKEY_MATCH") {
                let alertController = UIAlertController(title: NSLocalizedString("Avviso", comment: ""), message:notification.alertBody, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // messsage
                }
                alertController.addAction(OKAction)
                self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            }
    }
    
    // MARK: Push notifications
    
    func initPushNotifications() {
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            print("this is a simulator", terminator: "\n")
        #else
            print("this is a device", terminator: "\n")
            // registering for push notification
            UIApplication.sharedApplication().registerForRemoteNotifications()
        #endif
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // Called when registering for remote notifications doesn't work for some reason
        print("Failed to register for push notifications! \(error)", terminator: "\n")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Called when we've successfully registered for remote notifications.
        // Send the deviceToken to a server you control; it uses that token
        // to send pushes to this specific device.
        
        // Call APNS Server
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointBaseUrl = appDelegate.apnsBaseUrl
            
        // Add query string CMD
        var apnsTeamName = appDelegate.teamName.uppercaseString
        #if DEBUG
             apnsTeamName =  apnsTeamName + "_DEV"
        #endif
        let tokenDescription = deviceToken.description
        let tokenTrimmed = tokenDescription.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        let tokenWithoutSpaces = tokenTrimmed.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch , range: nil)
        let token = tokenWithoutSpaces
        let version = appDelegate.appVersion
        let endpointUrl = "\(endpointBaseUrl)?CMD=initapp&appkey=\(apnsTeamName)&devtoken=\(token)&custom=\(version)"
        //println("endpointUrl: " + endpointUrl)
        Alamofire.request(.GET, endpointUrl)
            .responseString {request, response, result in
                switch result {
                case .Success(let stringResult):
                    print("APNS - responseString: \(stringResult)")
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let dataFailure = data {
                        print("Response data: \(NSString(data: dataFailure, encoding: NSUTF8StringEncoding)!)")
                    }
                }
            }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        // Called when a remote notification arrives, but no action was selected 
        // or the notification came in while using the app
        // Do something with the information stored in userInfo
        
        // println("application.didReceiveRemoteNotification: ok")
        let state:UIApplicationState = application.applicationState
        // alert management for app in active state
        if (state == UIApplicationState.Active) {
            let notification:[NSObject : AnyObject] = userInfo["aps"] as! [NSObject : AnyObject]
            let alertBody : String = notification["alert"] as! String
            let alertController = UIAlertController(title: NSLocalizedString("Avviso", comment: ""), message:alertBody, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // messsage
            }
            alertController.addAction(OKAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
}