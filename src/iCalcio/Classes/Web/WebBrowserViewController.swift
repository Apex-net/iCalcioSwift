//
//  WebBrowserViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 10/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserViewController: UIViewController, WKNavigationDelegate {

    var browserTitle: String = ""
    var navigationUrl: String = ""
    
    @IBOutlet var containerView: UIView!
    var webView: WKWebView?

    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.webView?.navigationDelegate = self
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // title
        self.navigationItem.title = !self.browserTitle.isEmpty ? self.browserTitle : NSLocalizedString("Web Browser", comment: "")
        
        // load request
        var url = NSURL(string:self.navigationUrl)
        var req = NSURLRequest(URL: url)
        self.webView!.loadRequest(req)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - webView navigationDelegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func webView(webView: WKWebView, didFailProvisionalNavigation: WKNavigation, withError error: NSError){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        println("Error: " + error.description)
    }
    
    func webView(webView: WKWebView, didFailNavigation: WKNavigation, withError error: NSError){
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
