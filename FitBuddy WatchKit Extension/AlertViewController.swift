//
//  AlertViewController.swift
//  FitBuddy
//
//  Created by john.neyer on 5/7/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import WatchKit
import Foundation


class AlertViewController: WKInterfaceController {


    @IBOutlet weak var alertTextTitle: WKInterfaceLabel!
    @IBOutlet weak var alertTextLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    
        if let options = context as? NSDictionary {
            
            alertTextTitle.setText((options.objectForKey("title") as! String))
            alertTextLabel.setText((options.objectForKey("message") as! String))
        }
    }
    
    @IBAction func okButtonClicked() {
        dismissController()
    }

}