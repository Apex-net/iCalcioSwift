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
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert|UIUserNotificationType.Badge,categories:nil))
        
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
            println("this is a simulator")
        #else
            println("this is a device")
            // registering for push notification
            UIApplication.sharedApplication().registerForRemoteNotifications()
        #endif
        
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        // Called when registering for remote notifications doesn't work for some reason 
        println("Failed to register for push notifications! \(error)")
    }
    
    func application(application: UIApplication!,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        // Called when we've successfully registered for remote notifications.
        // Send the deviceToken to a server you control; it uses that token
        // to send pushes to this specific device.
        
        // Call APNS Server
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let endpointBaseUrl = appDelegate.apnsBaseUrl
            
        // Add query string CMD
        var apnsTeamName = appDelegate.teamName.uppercaseString
        #if DEBUG
             apnsTeamName =  apnsTeamName + "_DEV"
        #endif
        let tokenDescription = deviceToken.description
        let tokenTrimmed = tokenDescription.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        let tokenWithoutSpaces = tokenTrimmed.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        let token = tokenWithoutSpaces
        let version = appDelegate.appVersion
        let endpointUrl = "\(endpointBaseUrl)?CMD=initapp&appkey=\(apnsTeamName)&devtoken=\(token)&custom=\(version)"
        //println("endpointUrl: " + endpointUrl)
        Alamofire.request(.GET, endpointUrl)
            .responseString {(request, response, string, error) in
                if let err = error? {
                    println("Error: " + err.localizedDescription)
                }
                else {
                    println("APNS - responseString: " + string!)
                }
        }
    }
    
    func application(application: UIApplication!,
        didReceiveRemoteNotification userInfo: NSDictionary!) {
        // Called when a remote notification arrives, but no action was selected 
        // or the notification came in while using the app
        // Do something with the information stored in userInfo
        
        // println("application.didReceiveRemoteNotification: ok")
        let state:UIApplicationState = application.applicationState
        // alert management for app in active state
        if (state == UIApplicationState.Active) {
            let notification:NSDictionary = userInfo.objectForKey("aps") as NSDictionary
            let alertBody : String = notification.objectForKey("alert") as String
            let alertController = UIAlertController(title: NSLocalizedString("Avviso", comment: ""), message:alertBody, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // messsage
            }
            alertController.addAction(OKAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
    
}