//
//  TopScorersViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 26/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class TopScorersViewController: UITableViewController {
    
    private var topScorersList : [(goals: String, players: Array<Player>)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Cannonieri", comment: "")
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/TopScorers")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/TopScorers.txt"
        
        // reset temp array
        topScorersList.removeAll()
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {request, response, result in
                switch result {
                case .Success(let JSON):
                    //print("Success with JSON: \(JSON)")
                    if let JsonArray:AnyObject = JSON.valueForKeyPath("data"), parsedArray = JsonArray as? [AnyObject] {
                        let topScorers = parsedArray
                            .map({ obj in Player(attributes: obj) })
                        let sortedTopScorers = topScorers.sort{$0.goals > $1.goals}
                        var tempItems:Array<Player> = []
                        var oldGoals:String = String()
                        for item in sortedTopScorers{
                            let newGoals = item.goals
                            if newGoals == oldGoals {
                                // add to old section
                                tempItems.append(item)
                            }
                            else {
                                // close old section
                                if tempItems.count > 0 {
                                    let newData = (goals: oldGoals, players: tempItems)
                                    self.topScorersList.append(newData)
                                }
                                // init new section
                                tempItems.removeAll()
                                tempItems.append(item)
                                // set oldGoals
                                oldGoals = newGoals!
                            }
                        }
                        if tempItems.count > 0 {
                            let newData = (goals: oldGoals, players: tempItems)
                            self.topScorersList.append(newData)
                        }
                    }
                    // tableview reloading
                    self.tableView.reloadData()
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let dataFailure = data {
                        print("Response data: \(NSString(data: dataFailure, encoding: NSUTF8StringEncoding)!)")
                    }
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
        let sections = self.topScorersList.count
        return sections
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionTupla = self.topScorersList[section]
        let topScorers = sectionTupla.players
        
        return topScorers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopScorer", forIndexPath: indexPath)

        // Configure the cell...
        
        var player:Player?
        if self.self.topScorersList.count > 0 {
            player = self.topScorersList[indexPath.section].players[indexPath.row]
        }
        
        // set texts
        cell.textLabel?.text = player?.name
        cell.detailTextLabel?.text = player?.team
        
        // set font for my team
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let teamName:String = appDelegate.teamName
        let currentTeamName:String? = player?.team
        if currentTeamName?.lowercaseString.rangeOfString(teamName.lowercaseString) != nil {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        } else {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }


        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = String()
        if self.topScorersList.count > 0 {
            let titleSection: String = self.topScorersList[section].goals
            title = "\(titleSection) " +  NSLocalizedString("Goals", comment: "")
        }
        return title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
