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


class WorkoutCellType: NSObject {
    
    @IBOutlet weak var cellTitle: WKInterfaceLabel!
    @IBOutlet weak var cellSubtitle: WKInterfaceLabel!
    
    var nsData: Workout?
    
    func setNSData(workout: Workout) {
        
        nsData = workout
        
        if nsData != nil {
            cellTitle.setText(workout.workout_name)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            
            var workoutDateString = "never"
            
            if let lastWorkout = workout.last_workout {
                workoutDateString = dateFormatter.stringFromDate(lastWorkout)
            }
            
            cellSubtitle.setText("Last workout: " + workoutDateString)
        }
        
    }
    
}

