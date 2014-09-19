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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        item = ["text" : "Squadra",  "image" : "895-user-group"]
        teamItems.append(item)
        item = ["text" : "Partite",  "image" : "851-calendar"]
        teamItems.append(item)
        item = ["text" : "Stadio",  "image" : "723-location-arrow"]
        teamItems.append(item)

        item = ["text" : "Classifica",  "image" : "858-line-chart"]
        championshipItems.append(item)
        item = ["text" : "Cannonieri",  "image" : "784-target"]
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
        cell.textLabel!.text = dict["text"]

        // set image
        var imageName : String =  dict["image"]!
        var image : UIImage = UIImage(named:imageName)
        cell.imageView!.image = image
        
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
