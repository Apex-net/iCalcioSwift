//
//  ChannelsViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 16/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class ChannelsViewController: UITableViewController {
    
    private var youtubeChannels: Array<YoutubeChannel> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.navigationItem.title = NSLocalizedString("Youtube ", comment: "") + appDelegate.teamName
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
        // GA tracking
        appDelegate.trackScreen("/Channels")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/YouTubeChannels.txt"
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        //print("Success with JSON: \(JSON)")
                        if let JsonArray:AnyObject = JSON.valueForKeyPath("data"), parsedChannels = JsonArray as? [AnyObject] {
                            self.youtubeChannels = parsedChannels
                                .map({ obj in YoutubeChannel(attributes: obj) })
                        }
                        // tableview reloading
                        self.tableView.reloadData()
                    }
                } else {
                    print("Request failed with error: \(response.result.error)")
                    if let dataFailure = response.data {
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.youtubeChannels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Channel", forIndexPath: indexPath) 
                
        // Configure the cell...
        let channel = self.youtubeChannels[indexPath.row]
        
        // set texts
        cell.textLabel?.text = channel.title
        cell.detailTextLabel?.text = channel.subTitle

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = self.tableView.indexPathForSelectedRow
        let channel = self.youtubeChannels[indexPath!.row]
        if segue.identifier == "toChannelVideo" {
            let vc = segue.destinationViewController as! ChannelVideosViewController
            vc.youtubeChannel = channel
        }
        
    }

}
