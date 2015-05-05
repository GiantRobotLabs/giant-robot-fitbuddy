//
//  WorkoutSequence.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (WorkoutSequence)
public class WorkoutSequence: NSManagedObject {

    @NSManaged public var sequence: NSNumber
    @NSManaged public var exercise: Exercise
    @NSManaged public var workout: Workout

}
