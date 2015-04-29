//
//  CardioHistory.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (CardioHistory)
class CardioHistory: NSManagedObject {

    @NSManaged var comp: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var score: NSNumber

}
