//
//  ResistanceExercise.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (ResistanceExercise)
public class ResistanceExercise: Exercise {

    @NSManaged public var reps: String
    @NSManaged public var sets: String
    @NSManaged public var weight: String

}
