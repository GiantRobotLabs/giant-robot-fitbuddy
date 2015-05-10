//
//  WorkoutCellType.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import WatchKit
import FitBuddyModel
import FitBuddyCommon


class WorkoutCellType: NSObject {
    
    @IBOutlet weak var cellTitle: WKInterfaceLabel!
    @IBOutlet weak var cellSubtitle: WKInterfaceLabel!
    
    var nsData: Workout?
    
    func setNSData(workout: Workout) {
        
        nsData = workout
        updateCell()
    }
    
    func updateCell() {
        
        if nsData != nil {
            nsData!.managedObjectContext?.refreshObject(nsData!, mergeChanges: true)
            cellTitle.setText(nsData!.workout_name)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            
            cellSubtitle.setText("Last workout: " + WorkoutStartController.modelManager.getLastWorkoutDate(nsData!, withFormat: nil))
        }
    }
    
}

