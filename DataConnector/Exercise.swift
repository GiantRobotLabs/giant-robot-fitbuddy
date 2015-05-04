//
//  Exercise.swift
//  FitBuddy
//
//  Created by John Neyer on 5/4/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

class Exercise : RLMObject {
    
    dynamic var name: String?
    dynamic var notes: String?
    dynamic var sequence: NSNumber?
    dynamic var workouts: [Workout]?
    
    
    
}