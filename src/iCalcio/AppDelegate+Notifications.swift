//
//  AppDelegate+Notifications.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 14/10/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import Foundation

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
            
            println("Received local notification \(notification.category)!")
            
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
    
}