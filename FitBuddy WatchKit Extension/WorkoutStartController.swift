//
//  WorkoutListController.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import WatchKit

class WorkoutStartController: WKInterfaceController {
    
    @IBOutlet weak var workoutListView: WKInterfaceTable!

    func initView () {
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        workoutListView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowType: "WorkoutCellType");
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        initView();
        super.willActivate()
    
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startButonClicked() {
    }
    
    
}

