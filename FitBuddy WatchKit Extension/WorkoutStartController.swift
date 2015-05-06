//
//  WorkoutListController.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import WatchKit
import FitBuddyModel

class WorkoutStartController: WKInterfaceController {
    
    @IBOutlet weak var workoutListView: WKInterfaceTable!

    func initView () {
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        workoutListView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowType: "WorkoutCellType");
        let row = workoutListView.rowControllerAtIndex(0) as! WorkoutCellType
        let workout = CoreDataConnection().getAllWorkouts()
        
        if workout.count > 0 {
            row.cellTitle.setText(workout[0].workout_name)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            let subtitle = dateFormatter.stringFromDate(workout[0].last_workout)
            row.cellSubtitle.setText(subtitle)

        }
        
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

