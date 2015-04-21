//
//  WebBrowserViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 10/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import iAd

class WebBrowserViewController: UIViewController, UIWebViewDelegate{

    var browserTitle: String = ""
    var navigationUrl: String = ""
    
    var isNavBarEnabled: Bool = false
    
    private var segmentControl : UISegmentedControl?
    private var sharingBarItem : UIBarButtonItem?
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // title
        self.navigationItem.title = !self.browserTitle.isEmpty ? self.browserTitle : NSLocalizedString("Web Browser", comment: "")
        
        // load request
        var url = NSURL(string:self.navigationUrl)
        var req = NSURLRequest(URL: url!)
        self.webView!.loadRequest(req)
        self.webView!.scalesPageToFit = true
        
        // init navbar for navigation
        self.initNavBar()
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/MyWebBrowser")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        if UIApplication.sharedApplication().networkActivityIndicatorVisible == true{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - NavBar browser managment
    private func initNavBar()
    {
        if self.isNavBarEnabled {
            var buttons: [UIBarButtonItem] = []
            // sharing
            if let image = UIImage(named: "702-share-toolbar"){
                self.sharingBarItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "sharingAction:")
                buttons.append(sharingBarItem!)
            }
            // segment for web navigation bar
            var images: [UIImage] = []
            if let image = UIImage(named: "765-arrow-left-toolbar"){
                images.append(image)
            }
            if let image = UIImage(named: "766-arrow-right-toolbar"){
                images.append(image)
            }
            self.segmentControl = UISegmentedControl(items: images)
            self.segmentControl?.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: UIControlEvents.ValueChanged)
            let segmentBarItem : UIBarButtonItem = UIBarButtonItem(customView: self.segmentControl!)
            buttons.append(segmentBarItem)
            self.navigationItem.rightBarButtonItems = buttons
        }
    }

    func selectedSegmentDidChange(sender:UISegmentedControl!)
    {
        //println("selectedSegmentDidChange: method called")
        
        let segment : UISegmentedControl = sender
        
        switch (segment.selectedSegmentIndex) {
        case 0:
            // back
            webView.goBack()
        case 1:
            // forward
            webView.goForward()
        default:
            break
        }
        
    }
    
    func sharingAction(sender:AnyObject) {
        // share url
        if let url = NSURL(string:self.navigationUrl) {
            let items:[NSURL] = [url]
            // let's add a String and an NSURL
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityViewController.excludedActivityTypes =  [
                UIActivityTypePostToWeibo,
                UIActivityTypePrint,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeAirDrop
            ]
            activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
                // println("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
                if !success {
                    println("Cancelled activity")
                    return
                }
                if activity == UIActivityTypePostToFacebook {
                    println("Facebook activity")
                }
                if activity == UIActivityTypePostToTwitter {
                    println("Twitter activity")
                }
            }
            
            let presentationController = activityViewController.popoverPresentationController
            presentationController?.barButtonItem = self.sharingBarItem
            
            self.presentViewController(activityViewController,
                animated: true, completion: nil)
            
        }
    }
    
    private func enableSegmentNavItems() {
        
        if self.isNavBarEnabled {
            if let segment = self.segmentControl {
                segment.setEnabled(self.webView.canGoBack, forSegmentAtIndex: 0)
                segment.setEnabled(self.webView.canGoForward, forSegmentAtIndex: 1)
            }
        }
    }
    
    // MARK: - webView Delegate
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.navigationItem.title = NSLocalizedString("Caricamento...", comment: "")
        
        // Back-Forward buttons management
        self.enableSegmentNavItems()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.navigationItem.title = self.browserTitle
        
        // Back-Forward buttons management
        self.enableSegmentNavItems()
        
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.navigationItem.title = self.browserTitle
        
        // Back-Forward buttons management
        self.enableSegmentNavItems()
        
        println("Error webView: " + error.localizedDescription)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
