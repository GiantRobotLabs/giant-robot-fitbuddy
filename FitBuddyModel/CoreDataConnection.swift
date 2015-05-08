//
//  CoreDataConnection.swift
//  FitBuddy
//
//  Created by john.neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData
import FitBuddyCommon

public class CoreDataConnection : NSObject {
    
    override
    public init() {
        
    }
    
    public init(groupContext: Bool) {
        
        super.init()
        
        if groupContext {
            self.setGroupContext()
        }
    }
    
    lazy public var theLocalStore: NSURL = {
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (paths[0] as! NSURL).URLByAppendingPathComponent("Database").URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        }()
    
    
    lazy public var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    
    lazy public var managedObjectModel: NSManagedObjectModel = {
        
        let modelBundle = NSBundle(identifier: "com.giantrobotlabs.FitBuddy.FitBuddyModel")
        
        let modelURL = modelBundle!.URLForResource("GymBuddyModel", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
        }()
    
    lazy public var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType);
        return managedObjectContext
        }()

    
    lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
                
        let path = self.applicationDocumentsDirectory
        let dbDirURL = path.URLByAppendingPathComponent("Database")
        let storeURL = self.theLocalStore
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dbDirURL.path!))
        {
            var error: NSError? = nil
            NSFileManager.defaultManager().createDirectoryAtURL(dbDirURL, withIntermediateDirectories: false, attributes: nil, error: &error)
            
            if (error != nil)
            {
                NSLog("Unable to create directory for database: %@", error!)
            }
        }
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storeUrl = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Database").URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeWillChangeHandler", name:  NSPersistentStoreCoordinatorStoresWillChangeNotification, object: coordinator);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidChangeHandler" , name:  NSPersistentStoreCoordinatorStoresDidChangeNotification, object: coordinator);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidImportHandler" , name:  NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coordinator);
        
        return coordinator
        }()
    
    
    public func checkUpgradePath(upgradeFlag : Bool) -> Bool {
        
        let versionKey = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kAPPVERSIONKEY)
        
        if (versionKey != nil && versionKey != FBConstants.kAPPVERSION) {
            if (FBConstants.DEBUG) {
                NSLog("Migrating data for user")
            }
            
            if (upgradeFlag) {
                NSUserDefaults.standardUserDefaults().setObject(FBConstants.kAPPVERSION, forKey: FBConstants.kAPPVERSIONKEY)
            }
            
            if ((NSUserDefaults.standardUserDefaults().objectForKey(FBConstants.kEXPORTDBKEY)) != nil) {
                NSUserDefaults.standardUserDefaults().setObject("iTunes", forKey: FBConstants.kEXPORTDBKEY)
            }
        }
        
        return true
        
    }
    
    public func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
               
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    public func getAllWorkouts() -> [Workout] {
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: FBConstants.WORKOUT_TABLE)
        let sortDescriptor = NSSortDescriptor(key: "last_workout", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Workout] {
            return fetchResults
        }
        
        return []
    }
    
    public func getWorkoutSequence (workout: Workout) -> [WorkoutSequence] {
     
        let fetchRequest = NSFetchRequest(entityName: FBConstants.WORKOUT_SEQUENCE)
        fetchRequest.predicate = NSPredicate(format: "workout == %@", argumentArray: [workout])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: true)]
        
        if let fetchResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [WorkoutSequence] {
            return fetchResults
        }
        
        return []
    }
    
    public func newLogbookEntryFromWorkoutSequence (workoutSequence: WorkoutSequence) -> LogbookEntry {
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(FBConstants.LOGBOOK_TABLE, inManagedObjectContext: self.managedObjectContext!) as! LogbookEntry
        
        newEntry.workout = workoutSequence.workout
        newEntry.workout_name = workoutSequence.workout.workout_name
        newEntry.date = NSDate()
        newEntry.exercise_name = workoutSequence.exercise.name
        newEntry.notes = workoutSequence.exercise.notes
        newEntry.completed = true
        
        if workoutSequence.exercise is ResistanceExercise {
            
            let exercise = workoutSequence.exercise as! ResistanceExercise
            newEntry.weight = exercise.weight
            newEntry.sets = exercise.sets
            newEntry.reps = exercise.reps
        }
        
        if workoutSequence.exercise is CardioExercise {
            
            let exercise = workoutSequence.exercise as! CardioExercise
            newEntry.pace = exercise.pace
            newEntry.distance = exercise.distance
            newEntry.duration = exercise.duration
        }
        
        return newEntry;

    }
    
    public func deleteDataObject (nsManagedObject: NSManagedObject) {
        
        self.managedObjectContext?.deleteObject(nsManagedObject)
        saveContext()
        
        NSLog("Deleted managed object");

    }
    
    lazy public var sharedContainerPath : NSURL = {
        
        let fm = NSFileManager.defaultManager()
        return fm.containerURLForSecurityApplicationGroupIdentifier(FBConstants.kGROUPPATH)!
        
        }()
    
    
    public func configureGroupContainter () -> Bool {
        
        let groupDBDir = self.sharedContainerPath.URLByAppendingPathComponent("Database")
        let groupDBPath = groupDBDir.URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        
        let appDBDir = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Database")
        let appDBPath = appDBDir.URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        
        if !(NSFileManager.defaultManager().fileExistsAtPath(groupDBPath.path!)) {
            
            var error: NSError? = nil
            
            NSFileManager.defaultManager().createDirectoryAtPath(groupDBDir.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
            
            let directoryEnumerator = NSFileManager.defaultManager().enumeratorAtPath(appDBDir.path!)
            
            while let file = directoryEnumerator?.nextObject() as? String {
                
                if let fileUrl = NSURL(fileURLWithPath: file) {
                    
                    if NSFileManager.defaultManager().copyItemAtPath(appDBDir.URLByAppendingPathComponent(file).path!, toPath: groupDBDir.URLByAppendingPathComponent(fileUrl.lastPathComponent!).path!, error: &error) {
                    
                        NSFileManager.defaultManager().removeItemAtPath(appDBDir.URLByAppendingPathComponent(file).path!, error: &error)
                        
                    }
                }
            }
            
            if error != nil {
                NSLog("Unable to move database: %@", error!)
            }
        }
        
        self.applicationDocumentsDirectory = sharedContainerPath
        self.theLocalStore = groupDBPath
    
        return true
    }
    
    public func setGroupContext () {
        
        let fm = NSFileManager.defaultManager()
        let groupPath = fm.containerURLForSecurityApplicationGroupIdentifier(FBConstants.kGROUPPATH)!
        
        let groupDBDir = groupPath.URLByAppendingPathComponent("Database")
        let groupDBPath = groupDBDir.URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        self.applicationDocumentsDirectory = sharedContainerPath
        self.theLocalStore = groupDBPath

    }
    
    
    public func storeWillChangeHandler(sender: AnyObject) {
        
        if ((self.managedObjectContext) != nil) {
            if (FBConstants.DEBUG) {
                NSLog("Saving context prior to change.")
            }
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            self.managedObjectContext!.reset();
            
            if (error != nil) {
                NSLog("Error occured while saving context during prepare: %@", error!)
            }
            
        }
        
    }
    
    public func storeDidChangeHandler (sender: AnyObject) {
        
        if (self.managedObjectContext != nil)  {
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            
            if (error != nil) {
                NSLog("Error occured while saving context on change: %@", error!)
            }
            
            if (FBConstants.DEBUG) {
                NSLog("Store did change. Notify listeners");
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
            
        }
        
        
    }
    
    public func storeDidImportHandler(sender: AnyObject) {
        
        if (self.managedObjectContext != nil) {
            
            var error: NSError? = nil
            
            if (FBConstants.DEBUG) {
                NSLog("Store did change on import. Notify listeners")
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
        }
        
    }
}