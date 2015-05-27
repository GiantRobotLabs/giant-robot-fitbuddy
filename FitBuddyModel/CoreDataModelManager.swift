//
//  CoreDataModelManager.swift
//  FitBuddy
//
//  Created by john.neyer on 5/10/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import FitBuddyCommon

@objc
public class CoreDataModelManager: NSObject, ModelManager {
    
    var coreData : CoreDataConnection?
    
    public required init (connection : CoreDataConnection) {
        coreData = connection
    }
    
    public func getAllWorkouts() -> [Workout] {
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: FBConstants.WORKOUT_TABLE)
        let sortDescriptor = NSSortDescriptor(key: "last_workout", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = coreData!.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Workout] {
            return fetchResults
        }
        
        return []
    }
    
    public func getWorkoutSequence (workout: Workout) -> [WorkoutSequence] {
        
        let fetchRequest = NSFetchRequest(entityName: FBConstants.WORKOUT_SEQUENCE)
        fetchRequest.predicate = NSPredicate(format: "workout == %@", argumentArray: [workout])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: true)]
        
        if let fetchResults = coreData!.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [WorkoutSequence] {
            return fetchResults
        }
        
        return []
    }
    
    public func newLogbookEntryFromWorkoutSequence (workoutSequence: WorkoutSequence) -> LogbookEntry {
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(FBConstants.LOGBOOK_TABLE, inManagedObjectContext: coreData!.managedObjectContext) as! LogbookEntry
        
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
    
    public func getLastWorkoutDate (workout: Workout, withFormat: String? = nil) -> String {
        
        if workout.last_workout != nil
        {
            if withFormat != nil {
                return FitBuddyUtils.dateFromNSDate(workout.last_workout, format:withFormat!)
            }
            
            return FitBuddyUtils.shortDateFromNSDate(workout.last_workout)
        }
        else
        {
            if workout.logbookEntries.count == 0
            {
                return "never"
            }
        }
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sorted = workout.logbookEntries.sortedArrayUsingDescriptors([sortDescriptor])
        
        var completed = NSPredicate(format: "completed = 1");
        let filtered = sorted.filter { completed.evaluateWithObject($0) }
        
        let lastDate = (filtered[0] as! LogbookEntry).date
        
        workout.last_workout = lastDate
        workout.managedObjectContext?.save(nil)
        
        if withFormat != nil {
            return FitBuddyUtils.dateFromNSDate(workout.last_workout, format:withFormat!)
        }
        
        return FitBuddyUtils.shortDateFromNSDate(workout.last_workout)
    }
    
    public func getLogbookWorkoutsByDate () -> NSDictionary {
        
        var results = NSMutableDictionary()
        var queryResults = getAllLogbookEntries()
        
        if queryResults.count > 0 {
            
            for entry in queryResults {
                
                var entryDate = FitBuddyUtils.shortDateFromNSDate(entry.date_t)
                
                if var array = results.objectForKey(entryDate) as? NSMutableArray {
                    
                    if entry.workout != nil && !array.containsObject(entry.workout!) {
                        array.addObject(entry.workout!)
                    }
                }
                else {
                    
                    if entry.workout != nil {
                        results.setObject(NSMutableArray(array:[entry.workout!]), forKey: entryDate)
                    }
                }
                
            }
        }
        
        return results
        
    }
    
    public func getAllLogbookEntries () ->  [LogbookEntry] {
        
        let fetchRequest = NSFetchRequest(entityName: FBConstants.LOGBOOK_TABLE)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "completed = %@", argumentArray: [1])
        fetchRequest.predicate = predicate
        
        var error : NSError? = nil
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataConnection.defaultConnection.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [LogbookEntry] {
            return fetchResults
        }
        
        return []
    }
    
    public func getLogBookEntriesByWorkoutAndDate (workout: Workout, date: NSDate) -> [LogbookEntry] {
        
        
        
        return []
    }
    
    public func deleteDataObject (nsManagedObject: NSManagedObject) {
        
        coreData!.managedObjectContext.deleteObject(nsManagedObject)
        save()
        
        NSLog("Deleted managed object");
    }
    
    public func save () {
        
        var error: NSError? = nil
        if coreData!.managedObjectContext.hasChanges {
            coreData!.managedObjectContext.save(&error)
        }
        
        if error != nil {
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
    }

    public func exportData(destination: String) -> NSURL? {
        
        if destination == FBConstants.kITUNES {
            let archive = CoreDataArchive()
            return archive.exportToDisk(true)
        }
        
        NSLog("Unknown export type: %@", destination);
        return nil;
        
    }
    
    public func importData(reference: AnyObject?) {
        NSLog("importData for CoreDataModelManager is not implemented")
    }
    
    public func saveModel(modelObject: AnyObject?) {
        if modelObject is NSManagedObject {
            modelObject!.save()
        }
    }
    
    public func refreshModel(modelObject: AnyObject?) {
        if modelObject is NSManagedObject {
            CoreDataConnection.defaultConnection.managedObjectContext.refreshObject(modelObject as! NSManagedObject, mergeChanges: true)
        }
    }
    
}
