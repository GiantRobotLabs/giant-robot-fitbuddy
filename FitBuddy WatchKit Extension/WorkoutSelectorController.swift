//
//  WorkoutSelectorController.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import WatchKit
import FitBuddyModel
import FitBuddyCommon

class WorkoutSelectorController: WKInterfaceController {
    
    @IBOutlet weak var workoutTable: WKInterfaceTable!
    
    var parentController : WorkoutStartController?
    var workoutArray : [Workout]?
    
    func initView () {
        
        workoutArray = WorkoutStartController.coreDataConnection.getAllWorkouts()
    
        workoutTable.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, workoutArray!.count)), withRowType: "WorkoutCellType");

        for (index, workout) in enumerate(workoutArray!) {
            if let row = workoutTable.rowControllerAtIndex(index) as? WorkoutCellType {
                row.setNSData(workout)
            }
        }
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        let row = workoutTable.rowControllerAtIndex(rowIndex) as! WorkoutCellType
        NSLog("Row tapped: " + row.nsData!.workout_name)
        parentController?.selectedWorkout = row.nsData
        
        popController()
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        
        return nil
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
        
        if let parentContext = context as? WorkoutStartController {
            parentController = parentContext
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
    
}



