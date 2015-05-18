//
//  LogbookViewController.swift
//  FitBuddy
//
//  Created by john.neyer on 5/16/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import FitBuddyModel
import FitBuddyCommon

class LogbookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var logbookTableView: UITableView!
    
    //Logbook array data
    var tableData : [LogbookEntry]?
    
    // Dictionary of workout data keyed by date
    // NSDictionary (date: String, array: [WorkoutArrayData])
    var workoutData : NSMutableDictionary?
    var workoutExerciseData: NSMutableDictionary?
    
    // Array of section labels
    var sectionData : NSMutableSet?
    
    let logbookCellIdentifier = "Exercise Cell"
    let workoutCellIdentifier = "Workout Cell"
    
    var tableStyle = LogbookStyle.WORKOUT
    var workoutKey = ""
    
    func loadData() {
        tableData = AppDelegate.sharedAppDelegate().modelManager.getAllLogbookEntries()
        workoutData = sortWorkoutsByDate(tableData!)
    }
    
    override func viewDidLoad() {

        self.navigationItem.titleView = UIImageView(image: UIImage(named:FBConstants.kFITBUDDY))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupFetchedResultsController", name: FBConstants.kUBIQUITYCHANGED, object: nil)
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        var chart = LineChart()
        chart.y.labels.visible = false
        chart.y.axis.visible = false
        chart.frame = self.chartView.frame
        chart.frame.origin.x = 0
        chart.area = false
        chart.x.grid.visible = false
        chart.y.grid.visible = false
        self.chartView.addSubview(chart)

        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": chart]))
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": chart]))
        
        self.chartView.layoutIfNeeded()
        
        chart.addLine([3, 4, 9, 11, 13, 15])
    }
    
    override func viewDidAppear(animated: Bool) {
        //build the chart
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableData == nil {
            return 0
        }
        
        if tableStyle == LogbookStyle.WORKOUT {
            let key = (NSArray(array: workoutData!.allKeys)).objectAtIndex(section) as! String
            
            let entry = workoutData!.objectForKey(key) as! NSArray
            return entry.count
        }
        else if  tableStyle == LogbookStyle.EXERCISE {
            
            let logbookArray = self.workoutExerciseData!.objectForKey(self.workoutKey) as! NSSet
            return logbookArray.count
        }
        
        return tableData!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if sectionData != nil {
            return sectionData!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableStyle == LogbookStyle.EXERCISE {
            return exerciseCellAtIndexPath(indexPath)
        }
        
        return workoutCellAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return nil
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let key = (NSArray(array: workoutData!.allKeys)).objectAtIndex(section) as! NSString
        
        let labelView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40.0))
        labelView.backgroundColor = FBConstants.kCOLOR_LTGRAY
        labelView.autoresizesSubviews = false
        
        let label = UILabel(frame: CGRectMake(15, 5, tableView.frame.size.width, 40.0))
        label.font = UIFont.systemFontOfSize(12.0)
        label.text = key.uppercaseString
        label.textColor = FBConstants.kCOLOR_DKGRAY
        
        labelView.addSubview(label)
        return labelView
        
    }
    
    func exerciseCellAtIndexPath (indexPath:NSIndexPath) -> ExerciseLogCell {
        
        let cell = logbookTableView.dequeueReusableCellWithIdentifier(logbookCellIdentifier) as! ExerciseLogCell
        
        //let entry = tableData![indexPath.row] as LogbookEntry
        let logbookArray = self.workoutExerciseData!.objectForKey(self.workoutKey) as! NSSet
        let entry = NSArray(array: logbookArray.allObjects).objectAtIndex(indexPath.row) as! LogbookEntry
        
        if entry.duration != nil {
            cell.setCellValues(name: entry.exercise_name, workout: entry.workout_name, value: entry.duration, valueType: "duration", exerciseType: ExerciseType.CARDIO)
        } else {
            cell.setCellValues(name: entry.exercise_name, workout: entry.workout_name, value: entry.weight, valueType: "weight", exerciseType: ExerciseType.RESISTANCE)
        }
        
        return cell
    }
    
    func workoutCellAtIndexPath (indexPath:NSIndexPath) -> WorkoutLogCell {
    
        let cell = logbookTableView.dequeueReusableCellWithIdentifier(workoutCellIdentifier) as! WorkoutLogCell
        
        let keys = NSArray(array: self.workoutData!.allKeys)
        let key = keys.objectAtIndex(indexPath.section) as! String
        
        let values = workoutData?.objectForKey(key) as! NSArray
        let value = values[indexPath.row] as! WorkoutArrayData
        
        cell.setCellValues(name: value.name, date: value.date)
        
        return cell
    }
    
    //Build the workout array with tuple elements (date, name)
    func sortWorkoutsByDate (logbookData: [LogbookEntry]) -> NSMutableDictionary {
        
        //the mapping dictionary
        let workoutDict = NSMutableDictionary()
        
        //mapping dictionary for workout exercies
        // key = date + workout_name
        let exerciseDict = NSMutableDictionary()
        
        //set to track section headers
        let sectionArray = NSMutableSet()
    
        //array of date+workout_name
        let workoutPairs = NSMutableSet()
        
        for entry in logbookData {
    
            let dateString = FitBuddyUtils.dateFromNSDate(entry.date_t, format: "dd MMM yyyy")
            let workoutString = dateString + entry.workout_name
            
            if exerciseDict.objectForKey(workoutString) == nil {
                exerciseDict.setObject(NSMutableSet(), forKey: workoutString)
            }
            
            //!(workoutDict.objectForKey(dString) as! NSArray).containsObject(entry.workout_name)

            if !sectionArray.containsObject(dateString) || !workoutPairs.containsObject(workoutString) {
                
                let wdata = WorkoutArrayData()
                wdata.name = entry.workout_name
                wdata.date = dateString
                
                if let array = workoutDict.objectForKey(dateString) as? NSMutableArray {
                    array.addObject(wdata)
                }
                else
                {
                    workoutDict.setValue(NSMutableArray(array: [wdata]), forKey: dateString)
                    sectionArray.addObject(dateString)
                }
                
                workoutPairs.addObject(workoutString)
            }
            
            (exerciseDict.objectForKey(workoutString) as! NSMutableSet).addObject(entry)
        }
        
        self.sectionData = sectionArray
        self.workoutExerciseData = exerciseDict
        
        return workoutDict
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.logbookTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableStyle == LogbookStyle.WORKOUT {
            
            let keys = NSArray(array: self.workoutData!.allKeys)
            let key = keys.objectAtIndex(indexPath.section) as! String
            
            let values = workoutData?.objectForKey(key) as! NSArray
            let value = values[indexPath.row] as! WorkoutArrayData
            
            self.workoutKey = value.date + value.name
            
            self.performSegueWithIdentifier("WorkoutDetailsSeque", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WorkoutDetailsSeque" {
            let controller = segue.destinationViewController as! LogbookViewController
            controller.title = "Exercises"
            controller.tableStyle = LogbookStyle.EXERCISE
            controller.workoutKey = self.workoutKey
        }
        else {
            self.title = "Workouts"
        }
    }
}

class WorkoutArrayData: NSObject {
    var date: String = ""
    var name: String = ""
    var score: NSNumber = 0.0
}

enum LogbookStyle {
    case WORKOUT
    case EXERCISE
}

