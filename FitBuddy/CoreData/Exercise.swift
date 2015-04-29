//
//  Exercise.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (Exercise)
class Exercise: NSManagedObject {

    //@NSManaged var deleted: NSNumber
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var sequence: NSNumber
    @NSManaged var workouts: NSOrderedSet

}
