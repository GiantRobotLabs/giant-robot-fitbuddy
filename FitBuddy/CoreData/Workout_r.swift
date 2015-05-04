//
//  Workout_r.swift
//  FitBuddy
//
//  Created by john.neyer on 5/3/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData
import Realm

class Workout_r : RLMObject {
    
    dynamic var workout_name = ""
    dynamic var display  : NSNumber = 0
    dynamic var last_workout : NSDate?
    dynamic var exercises : NSOrderedSet?
    dynamic var logbookEntries: NSOrderedSet?
  
    dynamic var data : Workout?
    
    func setNSData (workout: Workout) {
    
        self.workout_name = workout.workout_name
        self.display = workout.display
        self.last_workout = workout.last_workout
        self.exercises = workout.exercises
        self.logbookEntries = workout.logbookEntries
        
        self.data = workout
    }
    
    func sync() {
        
        data!.workout_name = self.workout_name
        data!.display = self.display
        data!.last_workout = self.last_workout!
        data!.exercises = self.exercises!
        data!.logbookEntries = self.logbookEntries!
        
    }
}
