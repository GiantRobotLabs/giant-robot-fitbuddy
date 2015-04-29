//
//  WorkoutSequence.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc
class WorkoutSequence: NSManagedObject {

    @NSManaged var sequence: NSNumber
    @NSManaged var exercise: Exercise
    @NSManaged var workout: Workout

}
