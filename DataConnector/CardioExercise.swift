//
//  CardioExercise.swift
//  FitBuddy
//
//  Created by John Neyer on 5/4/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

class CardioExercise : RLMObject {
    
    dynamic var distance: String?
    dynamic var duration: String?
    dynamic var pace: String?
    
}