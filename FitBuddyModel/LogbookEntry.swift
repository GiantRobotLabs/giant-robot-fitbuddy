//
//  LogbookEntry.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (LogbookEntry)
public class LogbookEntry: NSManagedObject {

    @NSManaged public var completed: NSNumber
    @NSManaged public var date: NSDate
    // @NSManaged var date_t: NSDate
    @NSManaged public var distance: String
    @NSManaged public var duration: String
    @NSManaged public var exercise_name: String
    @NSManaged public var notes: String?
    @NSManaged public var pace: String
    @NSManaged public var reps: String
    @NSManaged public var sets: String
    @NSManaged public var weight: String
    @NSManaged public var workout_name: String
    @NSManaged public var workout: Workout
    
    lazy public var date_t : NSDate? = {
        
        let format: NSDateFormatter = NSDateFormatter.new()
        format.dateFormat = "dd MMM yyyy"
        if self.valueForKey("date") != nil {
            let dateOnly = format.stringFromDate(self.valueForKey("date") as! NSDate)
            return format.dateFromString(dateOnly)!
        }
        
        return nil
    }()

}
