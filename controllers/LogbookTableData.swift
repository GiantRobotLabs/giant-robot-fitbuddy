//
//  LogbookTableData.swift
//  FitBuddy
//
//  Created by john.neyer on 5/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import FitBuddyModel
import FitBuddyCommon

class LogbookTableData {
    
    var logbookData = [LogbookEntry]()

    var sectionData = Array<String>()
    var workoutData = Array<Array<WorkoutArrayData>>()
    
    func setData (logbookEntries: [LogbookEntry]) {
        logbookData = logbookEntries
        loadSections(logbookEntries)
        loadWorkouts(logbookEntries)
    }
    
    // Sections
    func numberOfSections () -> Int {
        return sectionData.count
    }
    
    func sectionAtIndex (index : Int) -> String {
        return sectionData[index] as String
    }

    func numberOfRowsInSection(section: Int) -> Int {
        
        if section >= workoutData.count || workoutData[section].isEmpty {
            return 0
        }

        return workoutData[section].count
    }

    // Workout data
    func workoutAtIndex(section: Int, index : Int) -> WorkoutArrayData {
        return workoutData[section][index]
    }
    
    func numberOfExercisesInWorkout(section: Int, index: Int) -> Int {
        return workoutAtIndex(section, index: index).exercises.count
    }
    
    func exerciseForWorktoutAtIndex(section: Int, workoutIndex: Int, exerciseIndex: Int) -> LogbookEntry {
        return workoutAtIndex(section, index: workoutIndex).exercises[exerciseIndex]
    }
    
    // Private loaders
    private func loadSections(entries: [LogbookEntry]) {
        
        sectionData = Array<String>()
        for entry in entries {
            let dateString = FitBuddyUtils.dateFromNSDate(entry.date_t, format: "dd MMM yyyy")
            
            if !contains(sectionData, dateString) {
                sectionData.append(dateString)
            }
        }
    }
    
    private func loadWorkouts(entries: [LogbookEntry]) {
        
        var workoutKeys = Array<String>()
        var dates = Array<String>()
        workoutData = Array<Array<WorkoutArrayData>>()
        
        for entry in entries {
            
            let dateString = FitBuddyUtils.dateFromNSDate(entry.date_t, format: "dd MMM yyyy")
            let key = dateString + entry.workout_name
            
            let workoutElement = WorkoutArrayData()
            workoutElement.name = entry.workout_name
            workoutElement.date = dateString
            
            // start a new array if needed
            if  !contains(dates, dateString) {
                dates.append(dateString)
                workoutData.append(Array<WorkoutArrayData>())
            }

            // Add a new workout element
            if !contains(workoutKeys, key) {
                workoutKeys.append(key)
                
                // add the workout array data to the array
                if var lastElement = workoutData.last {
                    lastElement.append(workoutElement)
                    workoutData.removeLast()
                    workoutData.append(lastElement)
                }
            }
            
            if var lastElement = workoutData.last {
                lastElement.last?.exercises.append(entry)
            }
        }
        
        //remove the last array if it's empty
        if workoutData.last != nil && workoutData.last!.isEmpty {
            workoutData.removeLast()
        }
    }
}

class WorkoutArrayData: NSObject {
    var date: String = ""
    var name: String = ""
    var score: NSNumber = 0.0
    var section = -1
    var exercises = Array<LogbookEntry>()
}

