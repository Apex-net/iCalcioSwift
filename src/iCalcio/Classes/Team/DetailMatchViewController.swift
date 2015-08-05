//
//  DetailMatchViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 29/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class DetailMatchViewController: UITableViewController, EKEventEditViewDelegate {

    var match: Match!
    
    private var actionsList : [(text: String, action: Actions, image: String)] = []
    
    private enum Actions {
        case AddToCalendar, AddNotification, toStadium
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = self.match.description

        // Set Data
        self.prepareArrayForTable()
        
        // Reloadata
        self.tableView.reloadData()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/MatchesDetail")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Set Data for Table view
    
    private func prepareArrayForTable() {
        
        self.actionsList.removeAll()
        
        // Append tuples to arrays
        self.actionsList += [(text:NSLocalizedString("Aggiungi al calendario", comment: ""), action: Actions.AddToCalendar, image:"851-calendar")]
        self.actionsList += [(text:NSLocalizedString("Aggiungi notifica", comment: ""), action: Actions.AddNotification, image:"719-alarm-clock")]
        self.actionsList += [(text:NSLocalizedString("Allo stadio", comment: ""), action: Actions.toStadium, image:"701-location")]
    
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.actionsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailMatch", forIndexPath: indexPath)
        // Configure the cell...
        
        let actionItem = self.actionsList[indexPath.row]
        
        // set texts
        cell.textLabel?.text = actionItem.text
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.textColor = UIColor.blueColor()
        
        // set image
        let imageName : String =  actionItem.image
        let image : UIImage? = UIImage(named:imageName)
        cell.imageView?.image = image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let titleString: String = "\(self.match.date) \(self.match.hour) " + NSLocalizedString("Risultato", comment: "") + ": \(self.match.result)"
        
        return titleString
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let actionItem = self.actionsList[indexPath.row]

        switch actionItem.action {
        case Actions.AddToCalendar:
            // Add a Calendar event
            self.addMatchEventToCalendar()
        case Actions.AddNotification:
            // Add a scheduled Notification
            self.scheduleLocalNotification()
        case Actions.toStadium:
            // Navigation to Stadium
            self.performSegueWithIdentifier("toStadiumMap", sender: nil)
        }
        
    }
    
    // MARK: - Actions management
    private func scheduleLocalNotification() {
        
        // init UILocalNotification
        let localNotification:UILocalNotification = UILocalNotification()
        
        // Local notification management
        let dateTimeFormatter = NSDateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let myStringDateTime = "\(self.match.date) \(self.match.hour)"
        let dateTimeEvent = dateTimeFormatter.dateFromString(myStringDateTime)
        if (dateTimeEvent != nil) {
            
            // only for debug: let fireDate = NSDate().dateByAddingTimeInterval(10)
            let fireDate = dateTimeEvent?.dateByAddingTimeInterval(-(15*60))
            localNotification.fireDate = fireDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertAction = NSLocalizedString("Dettagli", comment: "")
            localNotification.alertBody = NSLocalizedString("La partita \(self.match.description) \(myStringDateTime) comincia tra 15 minuti", comment: "")
            localNotification.category = "EVENTKEY_MATCH";
            
            // Local notification inserting: alert for user
            let alertController = UIAlertController(title: NSLocalizedString("Notifica", comment: ""), message: NSLocalizedString("Vuoi aggiungere un avviso 15 minuti prima che inizi la partita?", comment: ""), preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // Nothing
                UIApplication.sharedApplication().cancelLocalNotification(localNotification)
                print("Local notification: canceled")
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // Add local notification
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                print("Local notification: inserted")
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true){
                // Completion code
            }
            
        }
        
        
    }
    
    private func addMatchEventToCalendar() {
        
        // create an EKEventStore object
        let store : EKEventStore = EKEventStore()
        
        store.requestAccessToEntityType(EKEntityType.Event, completion: {
                success, error in
 
            print("EKEventStore: got permission = \(success); error = \(error)")
            // put your handler code here
            if (success == true) {
                // create new event
                let theEvent = EKEvent(eventStore: store)
                theEvent.title = self.match.description
                theEvent.timeZone = NSTimeZone.defaultTimeZone()
                // Combine Date + hour
                let dateTimeFormatter = NSDateFormatter()
                dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let myStringDateTime = "\(self.match.date) \(self.match.hour)"
                let dateTimeEvent = dateTimeFormatter.dateFromString(myStringDateTime)
                // Event Dates
                theEvent.startDate = dateTimeEvent!
                theEvent.endDate = (dateTimeEvent?.dateByAddingTimeInterval(105*60))!
                theEvent.calendar = store.defaultCalendarForNewEvents
                
                // Set a event edit controller
                let vc:EKEventEditViewController = EKEventEditViewController()
                vc.eventStore = store
                vc.event = theEvent
                vc.editViewDelegate = self
                self.presentViewController(vc, animated:true, completion: nil)
                
            }
            
        })
        
    }
    
    // MARK: - EKEventEditViewDelegate
    func eventEditViewController(controller: EKEventEditViewController,
            didCompleteWithAction action: EKEventEditViewAction){

        print("EKEventEditViewDelegate.didCompleteWithAction: \(action) \(action.rawValue)")
        
        let thisEvent:EKEvent = controller.event!
        switch action {
            case .Canceled:
                print("EKEventEditViewDelegate.didCompleteWithAction: EKEventEditViewActionCanceled")
            case .Saved:
                // save event
                do {
                    try controller.eventStore.saveEvent(thisEvent, span:EKSpan.ThisEvent)
                    print("EKEventEditViewDelegate.didCompleteWithAction: EKEventEditViewActionSaved")
                } catch let error as NSError {
                    print("EKEventEditViewDelegate.didCompleteWithAction: Not EKEventEditViewActionSaved - \(error.localizedDescription)")
                }
            case .Deleted:
                print("EKEventEditViewDelegate.didCompleteWithAction: EKEventEditViewActionDeleted")
        }
        
        // dismiss
        controller.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toStadiumMap" {
            let vc = segue.destinationViewController as! StadiumMapViewController
            vc.mapTitle = self.match.stadiumName!
            vc.mapLatitude = self.match.latitude!
            vc.mapLongitude = self.match.longitude!
            
        }
        
    }

}
