//
//  LogbookEntry.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (LogbookEntry)
class LogbookEntry: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    //@NSManaged var date_t: NSDate
    @NSManaged var distance: String
    @NSManaged var duration: String
    @NSManaged var exercise_name: String
    @NSManaged var notes: String
    @NSManaged var pace: String
    @NSManaged var reps: String
    @NSManaged var sets: String
    @NSManaged var weight: String
    @NSManaged var workout_name: String
    @NSManaged var workout: Workout
    
    lazy var date_t : NSDate = {
        
        let format: NSDateFormatter = NSDateFormatter.new()
        format.dateFormat = "dd MMM yyyy"
        
        let dateOnly = format.stringFromDate(self.valueForKey("date") as! NSDate)
        return format.dateFromString(dateOnly)!
        
    }()

}
