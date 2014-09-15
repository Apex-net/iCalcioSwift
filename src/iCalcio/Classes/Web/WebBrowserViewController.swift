//
//  WebBrowserViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 10/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import iAd

class WebBrowserViewController: UIViewController, UIWebViewDelegate, ADBannerViewDelegate {

    var browserTitle: String = ""
    var navigationUrl: String = ""
    
    var isNavBarEnabled: Bool = false
    
    private var adBannerView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // title
        self.navigationItem.title = !self.browserTitle.isEmpty ? self.browserTitle : NSLocalizedString("Web Browser", comment: "")
        
        // load request
        var url = NSURL(string:self.navigationUrl)
        var req = NSURLRequest(URL: url)
        self.webView!.loadRequest(req)
        self.webView!.scalesPageToFit = true
        
        // setup Ads
        self.loadAds()
        
        // init navbar for navigation
        self.initNavBar()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.layoutAnimated(false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.layoutAnimated(UIView.areAnimationsEnabled())
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        if UIApplication.sharedApplication().networkActivityIndicatorVisible == true{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - NavBar breowser managment
    private func initNavBar()
    {
        if self.isNavBarEnabled {
            let images: [UIImage] = [
                UIImage(named: "765-arrow-left-toolbar.png"),
                UIImage(named: "766-arrow-right-toolbar.png")
            ]
            var segment : UISegmentedControl = UISegmentedControl(items: images)
            segment.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: UIControlEvents.ValueChanged)
            
            var segmentBarItem : UIBarButtonItem = UIBarButtonItem(customView: segment)
            self.navigationItem.rightBarButtonItem = segmentBarItem
            
        }
    
    }

    func selectedSegmentDidChange(sender:UISegmentedControl!)
    {
        println("method called")
        
        // todo [!]
        
    }
    
    // MARK: - iAd banner managment
    private func loadAds(){
        adBannerView.delegate = self
        view.addSubview(adBannerView)
    }

    private func layoutAnimated(animated: Bool){
        
        // offset for tabbar
        let offsetHeightTabBar:CGFloat = 50
        
        // contentFrame as view bounds
        var contentFrame: CGRect = self.view.bounds

        // all we need to do is ask the banner for a size that fits into the layout area we are using
        var sizeForBanner: CGSize = adBannerView.sizeThatFits(contentFrame.size)

        // compute the ad banner frame
        var bannerFrame: CGRect = adBannerView.frame
        if adBannerView.bannerLoaded {
            // bring the ad into view
            contentFrame.size.height -= sizeForBanner.height // shrink down content frame to fit the banner below it
            bannerFrame.origin.y = contentFrame.size.height - offsetHeightTabBar
            bannerFrame.size.height = sizeForBanner.height
            bannerFrame.size.width = sizeForBanner.width
            // if the ad is available and loaded, shrink down the content frame to fit the banner below it,
            // we do this by modifying the vertical bottom constraint constant to equal the banner's height
            //
            var verticalBottomConstraint:NSLayoutConstraint = self.bottomConstraint
            verticalBottomConstraint.constant = sizeForBanner.height
            self.view.layoutSubviews()
        
        }
        else {
            // hide the banner off screen further off the bottom
            bannerFrame.origin.y = contentFrame.size.height
            
        }
        
        UIView.animateWithDuration(animated ? 0.25 : 0.0, animations: {
            self.webView.frame = contentFrame
            self.webView.layoutIfNeeded()
            self.adBannerView.frame = bannerFrame
            }, completion: {
                (value: Bool) in
                //println(">>> Animation done.")
        })

        
    }
    
    // MARK: - ADBannerViewDelegate
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("bannerViewDidLoadAd")
        
        self.layoutAnimated(true)
    }

    func bannerView(banner: ADBannerView!,
        didFailToReceiveAdWithError error: NSError!) {
        println("didFailToReceiveAdWithError: \(error.description)")
            
        self.layoutAnimated(true)
    }

    func bannerViewActionDidFinish(banner: ADBannerView!) {
        println("bannerViewActionDidFinish: banner view is finished an ad action")
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!,
        willLeaveApplication willLeave: Bool) -> Bool {

        println("bannerViewActionShouldBegin: banner view is beginning an ad action")
        return true
    }
    
    // MARK: - webView Delegate
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.navigationItem.title = NSLocalizedString("Caricamento...", comment: "")
        
        // enabling Back-Forward buttons [!]
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.navigationItem.title = self.browserTitle
        
        // enabling Back-Forward buttons [!]
        
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.navigationItem.title = self.browserTitle
        
        // enabling Back-Forward buttons [!]
        
        println("Error webView: " + error.description)
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
