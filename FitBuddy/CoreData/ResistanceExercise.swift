//
//  ResistanceExercise.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc
class ResistanceExercise: Exercise {

    @NSManaged var reps: String
    @NSManaged var sets: String
    @NSManaged var weight: String

}
