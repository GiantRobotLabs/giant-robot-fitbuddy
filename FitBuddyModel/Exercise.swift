//
//  Exercise.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (Exercise)
public class Exercise: NSManagedObject {

    // @NSManaged var deleted: NSNumber
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var sequence: NSNumber
    @NSManaged public var workouts: NSOrderedSet

}
