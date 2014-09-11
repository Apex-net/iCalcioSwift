//
//  WebBrowserViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 10/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import WebKit
import iAd

class WebBrowserViewController: UIViewController, UIWebViewDelegate, ADBannerViewDelegate {

    var browserTitle: String = ""
    var navigationUrl: String = ""
    
    var adBannerView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
    
    //@IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var webView: UIWebView!
    
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
        //loadAds()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - iAd banner managment
    func loadAds(){
        adBannerView = ADBannerView(frame: CGRect.zeroRect)
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        view.addSubview(adBannerView)
    }

    func layoutAnimated(animated: Bool){
        
        var contentFrame: CGRect = self.view.bounds

        // all we need to do is ask the banner for a size that fits into the layout area we are using
        var sizeForBanner: CGSize = adBannerView.sizeThatFits(contentFrame.size)

        // compute the ad banner frame
        var bannerFrame: CGRect = adBannerView.frame
        if adBannerView.bannerLoaded {
            // bring the ad into view
            contentFrame.size.height -= sizeForBanner.height // shrink down content frame to fit the banner below it
            bannerFrame.origin.y = contentFrame.size.height
            bannerFrame.size.height = sizeForBanner.height
            bannerFrame.size.width = sizeForBanner.width
            // if the ad is available and loaded, shrink down the content frame to fit the banner below it,
            // we do this by modifying the vertical bottom constraint constant to equal the banner's height
            //
            //var verticalBottomConstraint:NSLayoutConstraint = self.bottomConstraint
            //verticalBottomConstraint.constant = sizeForBanner.height
            //self.view.layoutSubviews()
        
        }
        else {
            // hide the banner off screen further off the bottom
            bannerFrame.origin.y = contentFrame.size.height
            
        }
        
    }
    
    // MARK: - ADBannerViewDelegate
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("bannerViewDidLoadAd")
    }

    func bannerView(banner: ADBannerView!,
        didFailToReceiveAdWithError error: NSError!) {
        println("didFailToReceiveAdWithError: \(error.description)")
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
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        println("Error: " + error.description)
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
