//
//  WorkoutListController.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import WatchKit
import FitBuddyModel
import FitBuddyCommon

class WorkoutStartController: WKInterfaceController {
    
    @IBOutlet weak var workoutListView: WKInterfaceTable!
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    var selectedWorkout : Workout?
    var workoutArray: [Workout]?
    
      static let coreDataConnection: CoreDataConnection = {
        let conn = CoreDataConnection()
        
        if FitBuddyUtils.isCloudOn() || CoreDataHelper2.coreDataUbiquityURL() != nil {
            conn.setUbiquityContext()
        }
        else {
            conn.setGroupContext()
        }
        
        return conn
        }()
    
    static let modelManager : ModelManager = {
        let mm = CoreDataModelManager(connection: WorkoutStartController.coreDataConnection)
        return mm
        }()

    func initView () {
        
        let row = workoutListView.rowControllerAtIndex(0) as! WorkoutCellType
        if selectedWorkout != nil {
            row.setNSData(selectedWorkout!)
        }
    }
       
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        workoutListView.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowType: "WorkoutCellType");

        let row = workoutListView.rowControllerAtIndex(0) as! WorkoutCellType
        workoutArray = WorkoutStartController.modelManager.getAllWorkouts()
        
        
        if let woContext = context as! Workout? {
            selectedWorkout = woContext
        }
        else if workoutArray!.count > 0 {
            selectedWorkout = workoutArray![0]
        }
    }
    
    func setStartButtonState() {
        if selectedWorkout != nil {
            startButton.setEnabled(true)
            startButton.setTitle("Start")
            startButton.setBackgroundImageNamed("red-watch-button")
        }
        else {
            startButton.setEnabled(false)
            startButton.setTitle(nil)
            startButton.setBackgroundImageNamed("gray-watch-button")
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        
        var context : AnyObject?
        
        if segueIdentifier == "SelectWorkoutSegue" {
            context = self
        }
        return context
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        var context : AnyObject?
        
        if segueIdentifier == "SelectWorkoutSegue" {
            context = self
        }
        
        return context
    }
    
    override func willActivate() {
        super.willActivate()
        initView();
        setStartButtonState()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startButonClicked() {
        
        if WorkoutStartController.modelManager.getWorkoutSequence(selectedWorkout!).count == 0 {
            
            let options = NSDictionary(objects: ["Empty workout: " +  selectedWorkout!.workout_name, "You need to add some exercises to start this workout."], forKeys: ["title", "message"])
            presentControllerWithName("AlertController", context: options)
        }
        else {
            
            presentControllerWithName("WorkoutController", context: selectedWorkout)
        }
        
        NSLog("Start button clicked")
    }
    
    
}

