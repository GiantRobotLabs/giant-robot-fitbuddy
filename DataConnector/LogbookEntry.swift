//
//  LogbookEntry.swift
//  FitBuddy
//
//  Created by John Neyer on 5/4/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

class LogbookEntry : RLMObject {
    
    dynamic var completed: NSNumber?
    dynamic var date: NSDate?
    dynamic var distance: String?
    dynamic var duration: String?
    dynamic var exercise_name: String?
    dynamic var notes: String?
    dynamic var pace: String?
    dynamic var reps: String?
    dynamic var sets: String?
    dynamic var weight: String?
    dynamic var workout_name: String?
    dynamic var workout: Workout?

    lazy var date_t : NSDate = {
        
        let format: NSDateFormatter = NSDateFormatter.new()
        format.dateFormat = "dd MMM yyyy"
        
        let dateOnly = format.stringFromDate(self.valueForKey("date") as! NSDate)
        return format.dateFromString(dateOnly)!
        
        }()

    
    
}