//
//  NewsViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 19/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class NewsViewController: UITableViewController, MWFeedParserDelegate {

    private var rssLinks: Array<RssLink> = Array()
    var feedItems = [MWFeedItem]()
    var countParsedFeeds:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationItem.title = NSLocalizedString("News ", comment: "") + appDelegate.teamName
        
        // todo
        // get all links
        // get feeds and parse ()
        // prepare sections/news
        // show news in tableview
        // 
        
        // links:
        //
        // https://github.com/mwaterfall/MWFeedParser
        //
        // https://github.com/wantedly/swift-rss-sample
        // https://github.com/JigarM/Swift-RSSFeed
        
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
        let endpointUrl = appDelegate.apiBaseUrl + "/feeds.txt"
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                //println(JSON)
                if let err = error? {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("data"){
                    if let parsedLinks = JsonArray as? [AnyObject] {
                        self.rssLinks = parsedLinks
                            .map({ obj in RssLink(attributes: obj) })
                    }
                    // tableview reloading
                    //self.tableView.reloadData()
                    
                    // todo: stop current parser

                    // 
                    
                    // Parse collection of feed urls
                    self.countParsedFeeds = 0
                    for item in self.rssLinks{
                        self.parseFeed(item.link)
                    }
                }
                // end refreshing
                //if self.refreshControl?.refreshing == true {
                //    self.refreshControl?.endRefreshing()
                //}
        }
    }
    
    private func parseFeed(feedUrl:String) {
        let URL = NSURL(string: feedUrl)
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
    }
    
    private func reloadTableViewWithParsedItems () {
        //
        var sortedItems:[MWFeedItem] = []
        var sortedResults = sorted(self.feedItems, {
            $0.date.compare($1.date) == NSComparisonResult.OrderedDescending
        })
        println("sortedResults: \(sortedResults)")
        
        for item in sortedResults{
            //
            
            
        }

        //
        self.tableView.reloadData()
    }

    // MARK: - MWFeedParser Delegate
    
    func feedParserDidStart(parser: MWFeedParser) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        println("feedParserDidStart")
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        println("feedParserDidFinish")
        
        self.countParsedFeeds++
        if self.countParsedFeeds == self.rssLinks.count {
            // it is the last feed
            self.reloadTableViewWithParsedItems()
        }
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        //println(info)
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        //println(item)
        self.feedItems.append(item)
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        println("MWFeedParser error: \(error.localizedDescription)")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.feedItems.count // temp [!]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("News", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        // temp [!]
        let feedItem = self.feedItems[indexPath.row]
        
        // set texts
        cell.textLabel!.text = feedItem.title != nil ? feedItem.title.stringByConvertingHTMLToPlainText() : "[No Title]"
        cell.detailTextLabel!.text = feedItem.summary != nil ? feedItem.summary.stringByConvertingHTMLToPlainText() : "[No Summary]"
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.sizeToFit()

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
