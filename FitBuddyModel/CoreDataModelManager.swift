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
        if let fetchResults = coreData!.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Workout] {
            return fetchResults
        }
        
        return []
    }
    
    public func getWorkoutSequence (workout: Workout) -> [WorkoutSequence] {
        
        let fetchRequest = NSFetchRequest(entityName: FBConstants.WORKOUT_SEQUENCE)
        fetchRequest.predicate = NSPredicate(format: "workout == %@", argumentArray: [workout])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sequence", ascending: true)]
        
        if let fetchResults = coreData!.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [WorkoutSequence] {
            return fetchResults
        }
        
        return []
    }
    
    public func newLogbookEntryFromWorkoutSequence (workoutSequence: WorkoutSequence) -> LogbookEntry {
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(FBConstants.LOGBOOK_TABLE, inManagedObjectContext: coreData!.managedObjectContext!) as! LogbookEntry
        
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
        
        let sortDescriptior = NSSortDescriptor(key: "date", ascending: false)
        let sorted = workout.logbookEntries.sortedArrayUsingDescriptors([sortDescriptior])
        let lastDate = (sorted[0] as! LogbookEntry).date
        
        workout.last_workout = lastDate
        workout.managedObjectContext?.save(nil)
        
        if withFormat != nil {
            return FitBuddyUtils.dateFromNSDate(workout.last_workout, format:withFormat!)
        }
        
        return FitBuddyUtils.shortDateFromNSDate(workout.last_workout)
    }
    
    public func deleteDataObject (nsManagedObject: NSManagedObject) {
        
        coreData!.managedObjectContext?.deleteObject(nsManagedObject)
        save()
        
        NSLog("Deleted managed object");
    }
    
    public func save () {
        if let moc = coreData!.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
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
    
}
