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
    private var feedItems = [MWFeedItem]()
    private var countParsedFeeds:Int = 0
    private var sectionsList : [[String:AnyObject]] = []
    private var feedParser : MWFeedParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationItem.title = NSLocalizedString("News ", comment: "") + appDelegate.teamName

        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()
        
        // GA tracking
        appDelegate.trackScreen("/News")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/feeds.txt"
        
        // reset temp array
        sectionsList.removeAll()
        feedItems.removeAll()
        
        // stop current parser
        self.feedParser?.stopParsing()

        // call feeds API
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {(request, response, JSON, error) in
                if let err = error? {
                    println("Error: " + err.localizedDescription)
                } else if let JsonArray:AnyObject = JSON?.valueForKeyPath("data"){
                    if let parsedLinks = JsonArray as? [AnyObject] {
                        self.rssLinks = parsedLinks
                            .map({ obj in RssLink(attributes: obj) })
                    }
                    
                    // Parse collection of feed urls
                    self.countParsedFeeds = 0
                    for item in self.rssLinks{
                        self.parseFeed(item.link)
                    }
                }
        }
    }
    
    // RefreshControl selector
    func refreshAction(sender:AnyObject) {
        self.refreshData()
    }
    
    private func parseFeed(feedUrl:String) {
        let URL = NSURL(string: feedUrl)
        self.feedParser = MWFeedParser(feedURL: URL);
        self.feedParser.delegate = self
        self.feedParser.feedParseType = ParseTypeFull
        self.feedParser.connectionType = ConnectionTypeAsynchronously
        self.feedParser.parse()
    }
    
    private func reloadTableViewWithParsedItems () {
        
        // ordering feed items
        var tempItems:[MWFeedItem] = []
        let sortedResults = sorted(self.feedItems, {
            $0.date.compare($1.date) == NSComparisonResult.OrderedDescending
        })

        // date formatter for NSDate
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd/MM/yyyy"
        
        // create sectionlist array
        var oldDate:String = String()
        for item in sortedResults{
            let newDate = dateStringFormatter.stringFromDate(item.date)
            if newDate == oldDate {
                // add to old section
                tempItems.append(item)
            }
            else {
                // close old section
                if tempItems.count > 0 {
                    let dict: [String: AnyObject] = ["section" : oldDate,  "data" : tempItems]
                    sectionsList.append(dict)
                }
                // init new section
                tempItems.removeAll()
                tempItems.append(item)
                // set old date
                oldDate = newDate
            }
        }
        if tempItems.count > 0 {
            let dict: [String: AnyObject] = ["section" : oldDate,  "data" : tempItems]
            sectionsList.append(dict)
        }
        //println("sectionsList \(sectionsList)")

        // reload tableview
        self.tableView.reloadData()
        
        // end refreshing
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - MWFeedParser Delegate
    
    func feedParserDidStart(parser: MWFeedParser) {
        println("feedParserDidStart")
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        println("feedParserDidFinish")
        self.countParsedFeeds++
        if self.countParsedFeeds == self.rssLinks.count {
            // it is the last feed
            self.reloadTableViewWithParsedItems()
        }
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        self.feedItems.append(item)
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        println("MWFeedParser error: \(error.localizedDescription)")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        let sections = self.sectionsList.count
        return sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        var feedItems = [MWFeedItem]()
        let arrayFeeds: AnyObject? = self.sectionsList[section]["data"]
        if let lfeeds = arrayFeeds as? [MWFeedItem] {
            feedItems = lfeeds
        }
        return feedItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("News", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        // get data for the cell
        var feedItems = [MWFeedItem]()
        var feedItem = MWFeedItem()
        if self.sectionsList.count > 0 {
            let arrayFeeds: AnyObject? = self.sectionsList[indexPath.section]["data"]
            if let arrayMWFeedItem = arrayFeeds as? [MWFeedItem] {
                feedItems = arrayMWFeedItem
            }
            feedItem = feedItems[indexPath.row]
        }
        
        // set texts
        cell.textLabel!.text = feedItem.title != nil ? feedItem.title.stringByConvertingHTMLToPlainText() : "[No Title]"
        cell.detailTextLabel!.text = feedItem.summary != nil ? feedItem.summary.stringByConvertingHTMLToPlainText() : "[No Summary]"
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.sizeToFit()

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = String()
        if self.sectionsList.count > 0 {
            let titleSection: AnyObject? = self.sectionsList[section]["section"]
            if let titleString = titleSection as? String {
                title = titleString
            }
        }
        return title
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
        
        let indexPath = tableView.indexPathForSelectedRow()
        var feedItems = [MWFeedItem]()
        var feedItem = MWFeedItem()
        if self.sectionsList.count > 0 {
            let arrayFeeds: AnyObject? = self.sectionsList[indexPath!.section]["data"]
            if let arrayMWFeedItem = arrayFeeds as? [MWFeedItem] {
                feedItems = arrayMWFeedItem
            }
            feedItem = feedItems[indexPath!.row]
        }
        
        if segue.identifier == "toWebBrowser" {
            let vc = segue.destinationViewController as WebBrowserViewController
            vc.browserTitle = feedItem.title
            vc.navigationUrl = feedItem.link
            vc.isNavBarEnabled = true
        }
    }

}
