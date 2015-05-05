//
//  CardioExercise.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (CardioExercise)
public class CardioExercise: Exercise {

    @NSManaged public var distance: String
    @NSManaged public var duration: String
    @NSManaged public var pace: String

}
