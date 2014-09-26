//
//  StadiumMapViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 25/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit

class StadiumMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = NSLocalizedString("Stadio", comment: "")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
