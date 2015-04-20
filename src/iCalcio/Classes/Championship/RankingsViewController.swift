//
//  RankingViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 26/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class RankingsViewController: UITableViewController {
    
    private var rankings: Array<Ranking> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Classifica", comment: "")
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/Rankings")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/Rankings.txt"
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                //println(JSON)
                if let err = error {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("data"){
                    if let parsedRankings = JsonArray as? [AnyObject] {
                        self.rankings = parsedRankings
                            .map({ obj in Ranking(attributes: obj) })
                    }
                    // tableview reloading
                    self.tableView.reloadData()
                    
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
        return self.rankings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ranking", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let ranking = self.rankings[indexPath.row]
        
        // set texts
        cell.textLabel?.text = ranking.description
        cell.detailTextLabel?.text = ranking.points
        
        // set font for my team
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let teamName:String = appDelegate.teamName
        let currentTeamName:String = ranking.description
        if currentTeamName.lowercaseString.rangeOfString(teamName.lowercaseString) != nil {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        } else {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }

        return cell
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
