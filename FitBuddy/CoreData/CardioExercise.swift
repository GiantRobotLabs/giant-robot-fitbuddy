//
//  CardioExercise.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (CardioExercise)
class CardioExercise: Exercise {

    @NSManaged var distance: String
    @NSManaged var duration: String
    @NSManaged var pace: String

}
