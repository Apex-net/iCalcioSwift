//
//  DetailMatchViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 29/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit

class DetailMatchViewController: UITableViewController {

    var match: Match!
    
    private var actionsList : [(text: String, action: Actions)] = []
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Set Data for Table view
    
    private func prepareArrayForTable() {
        
        self.actionsList.removeAll()
        
        // Append tuples to arrays
        self.actionsList.append(text:NSLocalizedString("Aggiungi al calendario", comment: ""), action: Actions.AddToCalendar)
        self.actionsList.append(text:NSLocalizedString("Aggiungi notifica", comment: ""), action: Actions.AddNotification)
        self.actionsList.append(text:NSLocalizedString("Allo stadio", comment: ""), action: Actions.toStadium)
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailMatch", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        let actionItem = self.actionsList[indexPath.row]
        
        // set texts
        cell.textLabel!.text = actionItem.text
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let titleString: String = "\(self.match.date) \(self.match.hour) " + NSLocalizedString("Risultato", comment: "") + ": \(self.match.result)"
        
        return titleString
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let actionItem = self.actionsList[indexPath.row]

        // [!] todo
        switch actionItem.action {
        case Actions.AddToCalendar:
            // Calendar
            println("TODO AddToCalendar")
        case Actions.AddNotification:
            // Notification
            println("TODO AddNotification")
        case Actions.toStadium:
            // Stadium
            println("TODO toStadium")
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
