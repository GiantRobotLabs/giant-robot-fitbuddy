//
//  DataConnector.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import Realm

public class DataConnector: NSObject {
    
    override
    public init() {
        
    }
    
    public func setupSharedData () {
        
        let mgr = NSFileManager.defaultManager()
        
        if let directory = mgr.containerURLForSecurityApplicationGroupIdentifier(Constants.kGROUPPATH) {
            
            let realmPath = directory.path!.stringByAppendingPathComponent(Constants.kREALMDB)
            
            RLMRealm.setDefaultRealmPath(realmPath)
            
        }
        
        let realm = RLMRealm.defaultRealm()
        
        realm.deleteAllObjects()
        
        let workouts = getAllWorkouts()

        for workout in workouts {
            
            let realmObj = Workout()
            realmObj.setNSData(workout!)
            realm.addObject(realmObj)
        }
        
        realm.commitWriteTransaction()
        
    }
    
    func getAllWorkouts() -> [NSDictionary?] {
/*
        var request = NSFetchRequest(entityName: Constants.WORKOUT_TABLE)
        request.sortDescriptors = NSArray(object: NSSortDescriptor(key: "last_workout", ascending: false)) as [AnyObject]
        
        let fetchResults = AppDelegate.sharedAppDelegate().managedObjectContext?.executeFetchRequest(request, error: nil) as! [NSDictionary]
*/
        
        var fetchResults : [NSDictionary?] = []
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