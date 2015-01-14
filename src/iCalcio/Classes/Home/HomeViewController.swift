//
//  HomeViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 04/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    private var sectionsList : [[[String : String]]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationItem.title = !appDelegate.appName.isEmpty ? appDelegate.appName : NSLocalizedString("Home", comment: "")
        
        // Set Data
        self.prepareArrayForTable()
        
        // GA tracking
        appDelegate.trackScreen("/Home")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    // MARK: - Set Data for Table view
    
    private func prepareArrayForTable() {
        
        self.sectionsList.removeAll()
        
        // Append some arrays
        var item : [String : String] = [:]
        var teamItems : [[String : String]] = []
        var championshipItems : [[String : String]] = []
        
        item = ["text" : NSLocalizedString("Squadra", comment: ""),  "image" : "895-user-group"]
        teamItems.append(item)
        item = ["text" : NSLocalizedString("Partite", comment: ""),  "image" : "851-calendar"]
        teamItems.append(item)
        item = ["text" : NSLocalizedString("Stadio", comment: ""),  "image" : "852-map"]
        teamItems.append(item)

        item = ["text" : NSLocalizedString("Classifica", comment: ""),  "image" : "858-line-chart"]
        championshipItems.append(item)
        item = ["text" : NSLocalizedString("Cannonieri", comment: ""),  "image" : "784-target"]
        championshipItems.append(item)
        
        self.sectionsList.append(teamItems)
        self.sectionsList.append(championshipItems)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Home", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        // get data for the cell
        let dict = self.sectionsList[indexPath.section][indexPath.row]
        
        // set text
        cell.textLabel?.text = dict["text"]!

        // set image
        var imageName : String =  dict["image"]!
        var image : UIImage? = UIImage(named:imageName)
        cell.imageView?.image = image
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String = ""
        
        switch section {
            case 0:
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                title = appDelegate.teamName
            case 1:
                title = NSLocalizedString("Campionato", comment: "")
            default:
                title = String()
        }
        
        return title
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            // team
            switch indexPath.row {
            case 0:
                self.performSegueWithIdentifier("toPlayers", sender: nil)
            case 1:
                self.performSegueWithIdentifier("toMatches", sender: nil)
            case 2:
                self.performSegueWithIdentifier("toStadiumMap", sender: nil)
            default:
                break
            }
        case 1:
            // championship
            switch indexPath.row {
            case 0:
                self.performSegueWithIdentifier("toRankings", sender: nil)
            case 1:
                self.performSegueWithIdentifier("toTopScorers", sender: nil)
            default:
                break
            }
        default:
            break
        }
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
