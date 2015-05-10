//
//  ModelManager.swift
//  FitBuddy
//
//  Created by john.neyer on 5/10/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation

@objc
public protocol ModelManager {
    
    func getAllWorkouts () -> [Workout]
    func getWorkoutSequence (workout: Workout) -> [WorkoutSequence]
    func newLogbookEntryFromWorkoutSequence (workoutSequence: WorkoutSequence) -> LogbookEntry 
    func getLastWorkoutDate (workout: Workout, withFormat : String?) -> String
    func deleteDataObject (nsManagedObject: NSManagedObject)
    func save ()
    
    func exportData (destination: String) -> NSURL?
    func importData (reference: AnyObject?)

}

