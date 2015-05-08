//
//  Workout.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (Workout)
public class Workout: NSManagedObject {

    //@NSManaged var deleted: NSNumber
    @NSManaged public var display: NSNumber
    @NSManaged public var last_workout: NSDate?
    @NSManaged public var workout_name: String
    @NSManaged public var exercises: NSOrderedSet
    @NSManaged public var logbookEntries: NSOrderedSet

}
