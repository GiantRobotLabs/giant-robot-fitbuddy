//
//  Workout_r.swift
//  FitBuddy
//
//  Created by john.neyer on 5/3/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

class Workout : RLMObject {
    
    dynamic var workout_name : String?
    dynamic var display  : NSNumber?
    dynamic var last_workout : NSDate?
    dynamic var exercises : [Exercise]?
    dynamic var logbookEntries: [LogbookEntry]?
    
    func setNSData (workout : NSDictionary) {
        
    }
/*
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
*/
}
