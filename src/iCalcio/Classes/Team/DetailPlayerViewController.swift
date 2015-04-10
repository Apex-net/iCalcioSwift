//
//  DetailPlayerViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 30/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit

class DetailPlayerViewController: UITableViewController {

    var player: Player!
    
    private var sectionsList : [[[String : String]]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = self.player.name
        
        // Set Data
        self.prepareArrayForTable()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/PlayerDetail")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Set Data for Table view
    
    private func prepareArrayForTable() {
        
        self.sectionsList.removeAll()
        
        // Append some arrays
        var item : [String : String] = [:]
        var playerItems : [[String : String]] = []
        
        if let team = self.player.team {
            item = ["text" : NSLocalizedString("Squadra", comment: ""),  "detailText" : team, "iSNote": "No"]
            playerItems.append(item)
        }
        if let goals = self.player.goals {
            item = ["text" : NSLocalizedString("Goals", comment: ""),  "detailText" : goals, "iSNote": "No"]
            playerItems.append(item)
        }
        if let born = self.player.born {
            item = ["text" : NSLocalizedString("Nato", comment: ""),  "detailText" : born, "iSNote": "No"]
            playerItems.append(item)
        }
        if let weight = self.player.weight {
            item = ["text" : NSLocalizedString("Peso", comment: ""),  "detailText" : weight, "iSNote": "No"]
            playerItems.append(item)
        }
        if let description = self.player.description {
            item = ["text" : NSLocalizedString("Note", comment: ""),  "detailText" : description, "iSNote": "Yes"]
            playerItems.append(item)
        }
        
        self.sectionsList.append(playerItems)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        let sections = self.sectionsList.count
        return sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let rows = self.sectionsList[section].count
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailPlayer", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        // get data for the cell
        let dict = self.sectionsList[indexPath.section][indexPath.row]
        
        // set text
        cell.textLabel?.text = dict["text"]!

        cell.detailTextLabel?.text = dict["detailText"]
        cell.detailTextLabel?.numberOfLines = 1
        if dict["iSNote"] == "Yes" {
            cell.detailTextLabel?.numberOfLines = 6
            let detailText : NSString = dict["detailText"]!
            cell.detailTextLabel?.text = detailText.stringByConvertingHTMLToPlainText()
            cell.detailTextLabel?.sizeToFit()
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var myHeight: CGFloat = 50
        let dict = self.sectionsList[indexPath.section][indexPath.row]
        if dict["iSNote"] == "Yes" {
            myHeight = 140
        }
        
        return myHeight
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
