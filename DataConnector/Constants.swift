//
//  FBConstants.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let kTITLEBAR = "titlebar"
    static let kFITBUDDY = "fitbuddy"
    static let kSTART = "start-button"
    static let kSTARTDISABLED = "start-disabled"
    static let kCARDIO = "toggle-run"
    static let kRESISTANCE = "toggle-workout"
    static let kCARDIOW = "workout-run"
    static let kRESISTANCEW = "workout-resistance"
    static let kCARDIOWHITE = "cardio-white"
    static let kRESISTANCEWHITE = "resistance-white"
    
    static let kCOLOR_RED = UIColor.init(red:222.0/255.0, green:11.0/255.0, blue:25.0/255.0, alpha:1)
    static let kCOLOR_GRAY = UIColor.init(red:173.0/255.0, green:175.0/255.0, blue:178.0/255.0, alpha:1)
    static let kCOLOR_RED_t = UIColor.init(red:222.0/255.0, green:11.0/255.0, blue:25.0/255.0, alpha:0.8)
    static let kCOLOR_GRAY_t = UIColor.init(red:173.0/255.0, green:175.0/255.0, blue:178.0/255.0, alpha:0.8)
    static let kCOLOR_LTGRAY = UIColor.init(red:239.0/255.0, green:239.0/255.0, blue:244.0/255.0, alpha:1)
    static let kCOLOR_DKGRAY = UIColor.init(red:109.0/255.0, green:109.0/255.0, blue:114.0/255.0, alpha:1)
    
    
    // DEBUG - Defined in Xcode project settings
    static let DEBUG = true
    
    // DATABASE
    static let kDATABASE2_0 = "FitBuddy.sqlite"
    static let kDATABASE1_0 = "GymBuddy"
    static let kEXPORTNAME = "FitBuddy"
    static let kEXPORTEXT = ".gbz"
    static let kUBIQUITYCONTAINER = "MK3WE6JNT9.com.giantrobotapps.FitBuddy"
    
    static let kGROUPPATH = "group.com.giantrobotapps.FitBuddy"
    static let kREALMDB = "db.realm"
    
    static let EXERCISE_TABLE = "Exercise"
    static let WORKOUT_TABLE = "Workout"
    static let LOGBOOK_TABLE = "LogbookEntry"
    static let CARDIO_EXERCISE_TABLE = "CardioExercise"
    static let RESISTANCE_EXERCISE_TABLE = "ResistanceExercise"
    static let RESISTANCE_HISTORY = "ResistanceHistory"
    static let CARDIO_HISTORY = "CardioHistory"
    static let RESISTANCE_LOGBOOK = "ResistanceLogbook"
    static let CARDIO_LOGBOOK = "CardioLogbook"
    static let WORKOUT_SEQUENCE = "WorkoutSequence"
    
    
    // DEFAULTS KEYS
    static let kAPPVERSIONKEY = "DataVersion"
    static let kAPPVERSION = "2.0"
    
    static let kDBVERSIONKEY = "DbVersion"
    static let kDBVERSION = "1.4.1"
    
    static let kUSEICLOUDKEY = "Use iCloud"
    static let kYES = "Yes"
    static let kNO = "No"
    static let kEXPORTDBKEY = "Export Database"
    static let kITUNES = "iTunes"
    
    // NOTIFICATIONS
    static let kCHECKBOXTOGGLED = "CheckboxToggled"
    static let kUBIQUITYCHANGED = "UbiquityChangedLocalStore"
    
    
}
