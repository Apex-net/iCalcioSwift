//
//  ChannelVideosViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 16/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class ChannelVideosViewController: UITableViewController {

    var youtubeChannel: YoutubeChannel!
    private var youtubeVideos: Array<YoutubeVideo> = Array()
    
    private var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = self.youtubeChannel.title
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshAllData("25")
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/ChannelVideos")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Data for Table view

    private func refreshAllData(maxResults: String) {
        
        // Call Youtube API for channel ID
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.youtubeBaseUrl + "/channels?" +
            "forUsername=\(youtubeChannel.channel)" +
            "&key=\(appDelegate.appYoutubeID)" +
            "&part=id"
        //println("endpointUrl youtube API channel ID:  \(endpointUrl)")
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                //println(JSON)
                if let err = error {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("items"){
                    if let parsedItems = JsonArray as? [AnyObject] {
                        //println(parsedItems)
                        if let channelID = parsedItems[0].valueForKeyPath("id") as? String {
                            // get all videos
                            self.getAllVideos(maxResults, forChannelID: channelID)
                        }
                    }
                }
                // end refreshing
                if self.refreshControl?.refreshing == true {
                    self.refreshControl?.endRefreshing()
                }
        }
    }
    
    private func getAllVideos(maxResults: String, forChannelID: String) {
        
        // Call Youtube API for videos in a channel
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.youtubeBaseUrl + "/search?" +
            "channelId=\(forChannelID)" +
            "&key=\(appDelegate.appYoutubeID)" +
            "&part=snippet" +
            "&order=date" +
            "&maxResults=\(maxResults)" +
            "&type=video"
        //println("endpointUrl youtube API videos for channel:  \(endpointUrl)")

        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                //println(JSON)
                if let err = error {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("items"){
                    if let parsedVideos = JsonArray as? [AnyObject] {
                        self.youtubeVideos = parsedVideos
                            .map({ obj in YoutubeVideo(attributes: obj) })
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    func refreshAction(sender:AnyObject!)
    {
        //println("refreshChannelVideos: method called")
        self.refreshAllData("50")
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.youtubeVideos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelVideo", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let video = self.youtubeVideos[indexPath.row]
        
        // set texts
        cell.textLabel?.text = video.title
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.text = video.updated.substringToIndex(advance(video.updated.startIndex, 10))
        
        // init image management
        let urlString = video.thumbnailURLString
        
        // set a placeholder for image
        cell.imageView?.image = UIImage(named: "thumbnail_placeholder")
        
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            if let imgURL: NSURL = NSURL(string: urlString) {
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let indexPath = self.tableView.indexPathForSelectedRow()
        let video = self.youtubeVideos[indexPath!.row]
        if segue.identifier == "toPlayVideo" {
            let vc = segue.destinationViewController as! PlayVideoViewController
            vc.youtubeVideo = video
        }
        
    }

}
