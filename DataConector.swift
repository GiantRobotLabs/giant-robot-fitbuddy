//
//  DataConnector.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData
import Realm

class DataConnector: NSObject {
    
    func setupSharedData () {
        
        let mgr = NSFileManager.defaultManager()
        var directory = mgr.containerURLForSecurityApplicationGroupIdentifier(FBConstants.kGROUPPATH)
        let realmPath = directory!.path!.stringByAppendingPathComponent(FBConstants.kREALMDB)
        RLMRealm.setDefaultRealmPath(realmPath)
        
        let realm = RLMRealm.defaultRealm()
        
        //if Workout_r.allObjects().count == 0 {
            
            realm.deleteAllObjects()
            
            let workouts = getAllWorkouts()
            
            for workout in workouts {
                
                let realmObj = Workout_r()
                realmObj.setNSData(workout)
                realm.addObject(realmObj)
            }
            
            realm.commitWriteTransaction()
            
        //}
        
    }
 
    func getAllWorkouts() -> [Workout] {
        
        var request = NSFetchRequest(entityName: FBConstants.WORKOUT_TABLE)
        request.sortDescriptors = NSArray(object: NSSortDescriptor(key: "last_workout", ascending: false)) as [AnyObject]
        
        let fetchResults = AppDelegate.sharedAppDelegate().managedObjectContext?.executeFetchRequest(request, error: nil) as! [Workout]
        
        return fetchResults
    }
    
    
    func startWorkout(workout: Workout) -> Workout? {
        
        return nil
    }
    
    func saveWorkout (workout: Workout) {
        
     
        
    }
    
    
    func saveExercise (exercise: Exercise) {
        
        
        
        
    }
}