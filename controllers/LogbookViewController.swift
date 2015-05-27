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
    
    let logbookCellIdentifier = "Exercise Cell"
    let workoutCellIdentifier = "Workout Cell"
    
    var tableStyle = LogbookStyle.WORKOUT
    
    var chartLabels = NSMutableArray()
    
    let chartData = LogbookChartData()
    let logbookTableData = LogbookTableData()
    
    var workoutSection = 0
    var workoutIndex = 0
    
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
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        logbookTableView.reloadData()
    }
    
    func loadData() {
        tableData = AppDelegate.sharedAppDelegate().modelManager.getAllLogbookEntries()
        chartData.setLogbookData(tableData!)
        logbookTableData.setData(tableData!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableStyle == LogbookStyle.WORKOUT {
            return logbookTableData.numberOfSections()
        }
        
        if tableStyle == LogbookStyle.EXERCISE {
            return 1
        }
        
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableStyle == LogbookStyle.WORKOUT {
            return logbookTableData.numberOfRowsInSection(section)
        }
            
        if  tableStyle == LogbookStyle.EXERCISE {
            return logbookTableData.numberOfExercisesInWorkout(workoutSection, index: workoutIndex)
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var text = ""
        
        if tableStyle == LogbookStyle.WORKOUT {
            text = logbookTableData.sectionAtIndex(section)
        }
        
        if tableStyle == LogbookStyle.EXERCISE {
            text = logbookTableData.sectionAtIndex(workoutSection)
        }
        
        let labelView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 35.0))
        labelView.backgroundColor = FBConstants.kCOLOR_LTGRAY
        labelView.autoresizesSubviews = false
        
        let label = UILabel(frame: CGRectMake(15, 0, tableView.frame.size.width, 35.0))
        label.font = UIFont.systemFontOfSize(12.0)
        label.text = text.uppercaseString
        label.textColor = FBConstants.kCOLOR_DKGRAY
        
        labelView.addSubview(label)
        return labelView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableStyle == LogbookStyle.EXERCISE {
            return exerciseCellAtIndexPath(indexPath)
        }
        
        return workoutCellAtIndexPath(indexPath)
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
    
    func exerciseCellAtIndexPath (indexPath:NSIndexPath) -> ExerciseLogCell {
        
        let cell = logbookTableView.dequeueReusableCellWithIdentifier(logbookCellIdentifier) as! ExerciseLogCell
    
        let entry = logbookTableData.exerciseForWorktoutAtIndex(workoutSection, workoutIndex: workoutIndex, exerciseIndex: indexPath.row)
        
        if entry.distance != nil {
            cell.setCellValues(name: entry.exercise_name, workout: entry.workout_name, value: entry.distance, valueType: "distance", exerciseType: ExerciseType.CARDIO)
        } else {
            cell.setCellValues(name: entry.exercise_name, workout: entry.workout_name, value: entry.weight, valueType: "weight", exerciseType: ExerciseType.RESISTANCE)
        }
        
        return cell
    }
    
    func workoutCellAtIndexPath (indexPath:NSIndexPath) -> WorkoutLogCell {
    
        let cell = logbookTableView.dequeueReusableCellWithIdentifier(workoutCellIdentifier) as! WorkoutLogCell
        let value = logbookTableData.workoutAtIndex(indexPath.section, index: indexPath.row)
        cell.setCellValues(name: value.name, date: value.date)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.logbookTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableStyle == LogbookStyle.WORKOUT {
            self.workoutSection = indexPath.section
            self.workoutIndex = indexPath.row
            self.performSegueWithIdentifier("WorkoutDetailsSeque", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WorkoutDetailsSeque" {
            let controller = segue.destinationViewController as! LogbookViewController
            controller.title = "Exercises"
            controller.tableStyle = LogbookStyle.EXERCISE
            controller.workoutSection = self.workoutSection
            controller.workoutIndex = self.workoutIndex
        }
        else {
            self.title = "Workouts"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let numberOfRows = logbookTableData.numberOfExercisesInWorkout(workoutSection, index: workoutIndex)
                cell.editing = true
                let entry = logbookTableData.exerciseForWorktoutAtIndex(workoutSection, workoutIndex: workoutIndex, exerciseIndex: indexPath.row)
                AppDelegate.sharedAppDelegate().modelManager.deleteDataObject(entry)
                
                //if this was the last row pop to root
                if numberOfRows == 1 {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
                loadData()
            }
            tableView.reloadData()
        }
    }
}

enum LogbookStyle {
    case WORKOUT
    case EXERCISE
}

