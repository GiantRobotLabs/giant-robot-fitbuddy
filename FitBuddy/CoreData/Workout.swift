//
//  Workout.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (Workout)
class Workout: NSManagedObject {

    //@NSManaged var deleted: NSNumber
    @NSManaged var display: NSNumber
    @NSManaged var last_workout: NSDate
    @NSManaged var workout_name: String
    @NSManaged var exercises: NSOrderedSet
    @NSManaged var logbookEntries: NSOrderedSet

}
