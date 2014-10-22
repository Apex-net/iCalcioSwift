//
//  AboutTableViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 19/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import MessageUI

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var mailto: UIButton!
    @IBOutlet weak var appStore: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = NSLocalizedString("About", comment: "")
        
        // init cell values
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if !appDelegate.appName.isEmpty {
            self.appName.text = appDelegate.appName
        }
        if !appDelegate.appVersion.isEmpty {
            self.version.text = NSLocalizedString("Build", comment: "") + ": " + appDelegate.appVersion
        }
        self.mailto.setTitle(NSLocalizedString("Contattaci", comment: ""), forState: UIControlState.Normal)
        self.appStore.setTitle(NSLocalizedString("Su Apple Store", comment: ""), forState: UIControlState.Normal)
        //self.mailto.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //self.appStore.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.facebookButton.setTitle(NSLocalizedString("Su Facebook", comment: ""), forState: UIControlState.Normal)
        //self.facebookButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        // GA tracking
        appDelegate.trackScreen("/Info")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // no, there are some static cells

    // MARK: - Actions
    @IBAction func didMailto(sender: AnyObject) {
        // open email composer
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@apexnet.it"])
        mailComposerVC.setSubject(NSLocalizedString("Richiesta informazioni", comment: ""))
        let appname = self.appName.text!
        let version = self.version.text!
        mailComposerVC.setMessageBody("\(appname) - \(version)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    @IBAction func didFacebook(sender: AnyObject) {
        // open page facebook
        self.performSegueWithIdentifier("toFacebook", sender: nil)
    }
    
    @IBAction func didAppleStore(sender: AnyObject) {
        // go to Apple store
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        UIApplication.sharedApplication().openURL(NSURL(string: appDelegate.appAppleStoreURL)!)
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if segue.identifier == "toFacebook" {
            let vc = segue.destinationViewController as WebBrowserViewController
            vc.browserTitle = NSLocalizedString("Apexnet", comment: "")
            vc.navigationUrl = appDelegate.appFacebookURL
            vc.isNavBarEnabled = true
         }
        
    }

}
