//
//  MatchesViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 25/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class MatchesViewController: UITableViewController {
    
    private var teamMatches: Array<Match> = Array()
    private var legTeamMatches: Array<Match> = Array()
    
    private enum Legs {
        case First, Second
    }
    private var currentLeg: Legs = Legs.First
    
    private var segmentControlLeg : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Partite", comment: "")
        
        // init Leg Settings
        self.initLegSettings()
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.trackScreen("/Matches")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Leg Management
    
    private func initLegSettings() {

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let teamInformation = appDelegate.teamInformation
        
        if let ti = teamInformation {
            let dateInitSecondLeg = teamInformation?.legDate
            //println(dateInitSecondLeg)
            var now = NSDate()
            
            /*
            // only for test
            var dayComponent: NSDateComponents = NSDateComponents()
            dayComponent.day = 120;
            let theCalendar : NSCalendar = NSCalendar.currentCalendar()
            let nextDate : NSDate = theCalendar.dateByAddingComponents(dayComponent, toDate: now, options: NSCalendarOptions(0))!
            now = nextDate
            */
            
            // set current leg
            let result = dateInitSecondLeg?.compare(now)
            if (result == NSComparisonResult.OrderedAscending) {
                self.currentLeg = .Second
            }
            else {
                self.currentLeg = .First
            }
        }
        
        // init segment control
        let elements: [String] = [NSLocalizedString("Andata", comment: ""), NSLocalizedString("Ritorno", comment: "")]
        self.segmentControlLeg = UISegmentedControl(items: elements)
        self.segmentControlLeg.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        //self.segmentControlLeg.momentary = true
        self.segmentControlLeg.selectedSegmentIndex = self.currentLeg == .First ? 0 : 1
        self.navigationItem.titleView = segmentControlLeg
        
    }

    func selectedSegmentDidChange(sender:UISegmentedControl!)
    {
        //println("selectedSegmentDidChange: method called")
        
        let segment : UISegmentedControl = sender
        
        switch (segment.selectedSegmentIndex) {
        case 0:
            // First leg
            self.currentLeg = .First
        case 1:
            // Second leg
            self.currentLeg = .Second
        default:
            break
        }
        
        // filter and tableview reloading
        self.filterContentForLeg()
        
    }
    
    private func filterContentForLeg() {

        self.legTeamMatches.removeAll()
        let legValue = self.currentLeg == .First ? "F" : "S"
        self.legTeamMatches = self.teamMatches.filter { $0.leg == legValue }
        
        self.tableView.reloadData()

    }
    
    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/Matches.txt"
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                //println(JSON)
                if let err = error? {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("data"){
                    if let parsedMatches = JsonArray as? [AnyObject] {
                        self.teamMatches = parsedMatches
                            .map({ obj in Match(attributes: obj) })
                    }
                    // filter and tableview reloading
                    self.filterContentForLeg()
                    
                }
                // end refreshing
                if self.refreshControl?.refreshing == true {
                    self.refreshControl?.endRefreshing()
                }
        }
    }
    
    // RefreshControl selector
    func refreshAction(sender:AnyObject) {
        self.refreshData()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.legTeamMatches.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Match", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let match = self.legTeamMatches[indexPath.row]
        
        // set texts
        cell.textLabel.text = match.description
        cell.detailTextLabel!.text = "\(match.date) \(match.hour) " + NSLocalizedString("Risultato", comment: "") + ": \(match.result)"
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let indexPath = self.tableView.indexPathForSelectedRow()
        let match = self.legTeamMatches[indexPath!.row]
        if segue.identifier == "toDetailMatch" {
            let vc = segue.destinationViewController as DetailMatchViewController
            vc.match = match
        }
        
    }

}
