//
//  WorkoutSequence.swift
//  FitBuddy
//
//  Created by John Neyer on 5/4/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

class WorkoutSequence : RLMObject {
    
    dynamic var sequence: NSNumber?
    dynamic var exercise: Exercise?
    dynamic var workout: Workout?
    
    
}