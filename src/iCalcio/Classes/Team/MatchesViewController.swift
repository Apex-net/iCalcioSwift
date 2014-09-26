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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Partite", comment: "")
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return self.teamMatches.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Match", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let match = self.teamMatches[indexPath.row]
        
        // set texts
        cell.textLabel!.text = match.description
        cell.detailTextLabel!.text = match.date + " " + match.hour
        
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
