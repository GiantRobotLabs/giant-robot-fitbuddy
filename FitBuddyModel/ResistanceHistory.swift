//
//  ResistanceHistory.swift
//  FitBuddy
//
//  Created by John Neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData

@objc (ResistanceHistory)
public class ResistanceHistory: NSManagedObject {

    @NSManaged public var comp: NSNumber
    @NSManaged public var date: NSDate
    @NSManaged public var score: NSNumber

}
