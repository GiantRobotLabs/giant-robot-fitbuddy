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
    
    var chartLabels = NSMutableArray()
    
    let chartData = LogbookChartData()
    
    lazy var chart : LineChart = {
        var chart = LineChart()
        chart.y.labels.visible = false
        chart.y.axis.visible = false
        chart.x.labels.visible = true
        chart.frame = self.chartView.frame
        chart.frame.origin.x = 0
        chart.area = false
        chart.x.grid.visible = false
        chart.y.grid.visible = false
        chart.showZeros = false
        chart.lineWidth = 0.0
        self.chartView.addSubview(chart)
        
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": chart]))
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": chart]))
        
        self.chartView.layoutIfNeeded()
        
        return chart
    }()
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named:FBConstants.kFITBUDDY))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupFetchedResultsController", name: FBConstants.kUBIQUITYCHANGED, object: nil)
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        
        // Initialize the chart
        chart.clearAll()

        //Set chart values
        self.chartLabels = NSMutableArray(array: chartData.lastThirty())
    
        let first = self.chartLabels.firstObject as! String
        
        //remove every fifth element day string
        for index in 1...self.chartLabels.count {
            if index % 5 != 0 {
                self.chartLabels[self.chartLabels.count - 1 - index] =  ""
            }
        }
        
        self.chartLabels[0] = first
        
        chart.x.labels.values = self.chartLabels as [AnyObject] as! [String]
        chart.addLine(chartData.normalizedResistanceArray() as [AnyObject] as! [CGFloat])
        chart.addLine(chartData.normalizedCardioArray() as [AnyObject] as! [CGFloat])
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        logbookTableView.reloadData()
    }
    
    func loadData() {
        tableData = AppDelegate.sharedAppDelegate().modelManager.getAllLogbookEntries()
        workoutData = sortWorkoutsByDate(tableData!)
        chartData.setLogbookData(tableData!)
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
            
            if let logbookArray = self.workoutExerciseData!.objectForKey(self.workoutKey) as? NSSet {
                return logbookArray.count
            }
            return 0
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
        
        if tableStyle == LogbookStyle.EXERCISE {
            return true
        }
        
        return false
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
        
        if entry.distance != nil {
            cell.setCellValues(name: entry.exercise_name, workout: entry.workout_name, value: entry.distance, valueType: "distance", exerciseType: ExerciseType.CARDIO)
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                //Update the cell or model
                cell.editing = true
                let logbookArray = self.workoutExerciseData!.objectForKey(self.workoutKey) as! NSSet
                let entry = NSArray(array: logbookArray.allObjects).objectAtIndex(indexPath.row) as! LogbookEntry
                AppDelegate.sharedAppDelegate().modelManager.deleteDataObject(entry)
                loadData()
            }
            tableView.reloadData()
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

