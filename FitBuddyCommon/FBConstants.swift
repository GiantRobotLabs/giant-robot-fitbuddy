//
//  FBConstants.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit

public class FBConstants {
    
    public static let kTITLEBAR = "titlebar"
    public static let kFITBUDDY = "fitbuddy"
    public static let kSTART = "start-button"
    public static let kSTARTDISABLED = "start-disabled"
    public static let kCARDIO = "toggle-run"
    public static let kRESISTANCE = "toggle-workout"
    public static let kCARDIOW = "workout-run"
    public static let kRESISTANCEW = "workout-resistance"
    public static let kCARDIOWHITE = "cardio-white"
    public static let kRESISTANCEWHITE = "resistance-white"
    
    public static let kCOLOR_RED = UIColor.init(red:222.0/255.0, green:11.0/255.0, blue:25.0/255.0, alpha:1)
    public static let kCOLOR_GRAY = UIColor.init(red:173.0/255.0, green:175.0/255.0, blue:178.0/255.0, alpha:1)
    public static let kCOLOR_RED_t = UIColor.init(red:222.0/255.0, green:11.0/255.0, blue:25.0/255.0, alpha:0.8)
    public static let kCOLOR_GRAY_t = UIColor.init(red:173.0/255.0, green:175.0/255.0, blue:178.0/255.0, alpha:0.8)
    public static let kCOLOR_LTGRAY = UIColor.init(red:239.0/255.0, green:239.0/255.0, blue:244.0/255.0, alpha:1)
    public static let kCOLOR_DKGRAY = UIColor.init(red:109.0/255.0, green:109.0/255.0, blue:114.0/255.0, alpha:1)
    
    
    // DEBUG - Defined in Xcode project settings
    public static let DEBUG = true
    
    // DATABASE
    public static let kDATABASE2_0 = "FitBuddy.sqlite"
    public static let kDATABASE2_0REMOTE = "RemoteFitBuddy.sqlite"

    public static let kDATABASE1_0 = "GymBuddy"
    public static let kEXPORTNAME = "FitBuddy"
    public static let kEXPORTEXT = ".gbz"
    public static let kUBIQUITYCONTAINER = "MK3WE6JNT9.com.giantrobotapps.FitBuddy"
    public static let NSPersistentStoreUbiquitousContentNameKey = "iCloudStore"
    public static let kGROUPPATH = "group.com.giantrobotapps.FitBuddy"
    public static let kREALMDB = "db.realm"
    public static let kUSEICLOUDKEY = "Use iCloud"
    public static let kUBIQUITYURLKEY = "iCloud Doc URL"
    
    public static let EXERCISE_TABLE = "Exercise"
    public static let WORKOUT_TABLE = "Workout"
    public static let LOGBOOK_TABLE = "LogbookEntry"
    public static let CARDIO_EXERCISE_TABLE = "CardioExercise"
    public static let RESISTANCE_EXERCISE_TABLE = "ResistanceExercise"
    public static let RESISTANCE_HISTORY = "ResistanceHistory"
    public static let CARDIO_HISTORY = "CardioHistory"
    public static let RESISTANCE_LOGBOOK = "ResistanceLogbook"
    public static let CARDIO_LOGBOOK = "CardioLogbook"
    public static let WORKOUT_SEQUENCE = "WorkoutSequence"
    
    
    // DEFAULTS KEYS
    public static let kAPPVERSIONKEY = "DataVersion"
    public static let kAPPVERSION = "2.0"
    
    public static let kDBVERSIONKEY = "DbVersion"
    public static let kDBVERSION = "1.4.1"
    
    public static let kYES = "Yes"
    public static let kNO = "No"
    public static let kEXPORTDBKEY = "Export Database"
    public static let kITUNES = "iTunes"
    
    // NOTIFICATIONS
    public static let kCHECKBOXTOGGLED = "CheckboxToggled"
    public static let kUBIQUITYCHANGED = "UbiquityChangedLocalStore"
    
    public static let WKGREEN = UIColor.greenColor();
    public static let WKORANGE =  UIColor.orangeColor();
    public static let WKGRAY =  UIColor.lightGrayColor();
    
    public static let kRESISTANCEINCKEY = "Resistance Increment"
    public static let kCARDIOINCKEY = "Cardo Increment"
    
    // SEGUES
    public static let ADD_EXERCISE_SEGUE = "Add Exercise Segue"
    public static let ADD_WORKOUT_SEGUE = "Add Workout Segue"
    public static let START_WORKOUT_SEGUE = "Start Workout Segue"
    public static let WORKOUT_MODE_SEGUE = "Segue To Me"
    public static let WORKOUT_REVERSE_SEGUE = "Go Back To Me Segue"
    public static let GO_HOME_SEGUE = "Go Home Segue"
    public static let NOTES_SEGUE = "Segue To Notes"
    public static let SETTINGS_SEGUE = "Segue to Settings"
    public static let DEMO_SEGUE = "Segue to Demo"
    public static let LOGBOOK_SHOWMOREDATA_SEGUE = "Show More Data"
    
    public static let kDEFAULT_RESISTANCE_SETTINGS = ["0.5", "1.0", "2.0", "2.5", "5.0"]
    public static let kDEFAULT_CARDIO_SETTINGS = ["0.1", "0.2", "0.3", "0.4", "0.5", "1.0", "2.0", "2.5", "5.0"]
    public static let kDEFAULT_BOOLEAN_OPTIONS = ["Yes", "No"]
    public static let kDEFAULT_EXPORT_TYPES = ["iTunes"]
    
}
