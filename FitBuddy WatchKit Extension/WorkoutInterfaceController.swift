//
//  InterfaceController.swift
//  FitBuddy WatchKit Extension
//
//  Created by john.neyer on 4/25/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import WatchKit
import Foundation
import FitBuddyModel
import FitBuddyCommon

class WorkoutInterfaceController: WKInterfaceController {

    @IBOutlet weak var previousButton: WKInterfaceButton!
    
    @IBOutlet weak var nextButton: WKInterfaceButton!
    
    @IBOutlet weak var exerciseNameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var exerciseDescriptionLabel: WKInterfaceLabel!
    
    @IBOutlet weak var skipButton: WKInterfaceButton!
    
    @IBOutlet weak var logButton: WKInterfaceButton!
    
    @IBOutlet weak var slot1Label: WKInterfaceLabel!
    @IBOutlet weak var slot1Value: WKInterfaceLabel!
    
    @IBOutlet weak var slot2Label: WKInterfaceLabel!
    @IBOutlet weak var slot2Value: WKInterfaceLabel!
    
    @IBOutlet weak var slot3Label: WKInterfaceLabel!
    @IBOutlet weak var slot3Value: WKInterfaceLabel!
    
    @IBOutlet weak var slot1Slider: WKInterfaceSlider!
    
    @IBOutlet weak var slot2Slider: WKInterfaceSlider!
    
    @IBOutlet weak var slot3Slider: WKInterfaceSlider!
    
    var exerciseName: NSString = ""
    
    var cardio = false
    
    var slot1: NSNumber = 0.0
    var slot2: NSNumber = 0.0
    var slot3: NSNumber = 0.0
    
    var slot1New: NSNumber = 0.0
    var slot2New: NSNumber = 0.0
    var slot3New: NSNumber = 0.0
    
    var slot1Text: NSString = ""
    var slot2Text: NSString = ""
    var slot3Text: NSString = ""
    
    var slot1Increment: NSNumber = 0.0
    var slot2Increment: NSNumber = 0.0
    var slot3Increment: NSNumber = 0.0
    
    var currentWorkout : Workout?
    var workoutSequence : [WorkoutSequence]?
    var currentExercise : Exercise?
    
    var logs: [LogbookEntry?]?
    var skipped: [Bool?]?
    
    var currentIndex = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        if let workout = context as? Workout {
            currentWorkout = workout
        }
    }

    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        workoutSequence = WorkoutStartController.coreDataConnection.getWorkoutSequence(currentWorkout!)
        
        logs = [LogbookEntry?](count:workoutSequence!.count, repeatedValue: nil)
        skipped = [Bool?](count:workoutSequence!.count, repeatedValue: nil)
        
        loadForm()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        WorkoutStartController.coreDataConnection.saveContext()
        
        WKInterfaceController.openParentApplication(["orderNumber": ""] , reply: { (reply, error) -> Void in});
        super.didDeactivate()
    }
    
    @IBAction func changeSlot1(value: Float) {
        
        let cvalue = value * slot1Increment.floatValue
        
        if slot1.floatValue + value < 0 {
            //do nothing
            slot1Slider.setValue(value + 1)
            return
        }
        
        slot1New = slot1.floatValue + cvalue;
        slot1Value.setText(slot1New.stringValue);
        
        if cardio {
            slot3New = slot1New.floatValue * slot2New.floatValue
            slot3Value.setText(slot3New.stringValue)
        }
        
        changeSliderColor(slot1Slider, value: value);
        updateExerciseDescription()
    }
    
    @IBAction func changeSlot2(value: Float) {
        
        let cvalue = value * slot2Increment.floatValue
        
        if slot2.floatValue + value < 0 {
            //do nothing
            slot2Slider.setValue(value + 1)
            return
        }
        
        slot2New = slot2.floatValue + cvalue;
        slot2Value.setText(slot2New.stringValue);
        
        changeSliderColor(slot2Slider, value: value);
        updateExerciseDescription()
    }

    @IBAction func changeSlot3(value: Float) {
        
        let cvalue = value * slot3Increment.floatValue
        
        if slot3.floatValue + value < 0 {
            //do nothing
            slot3Slider.setValue(value + 1)
            return
        }
        
        slot3New = slot3.floatValue + cvalue;
        slot3Value.setText(slot3New.stringValue);
        
        if cardio {
            slot1New = slot3New.floatValue / slot2New.floatValue
            slot1Value.setText(slot1New.stringValue)
        }

        changeSliderColor(slot3Slider, value: value);
        updateExerciseDescription()
    }
    

    @IBAction func skipButtonPressed() {
        
        if let entry = logs![currentIndex] {
            WorkoutStartController.coreDataConnection.deleteDataObject(entry)
        }
        
        logs![currentIndex] = nil
        skipped![currentIndex] = true
        
        setButtonColor()
    }
    
    
    @IBAction func logButtonPressed() {
        
        commitForm()
        
        if let entry = logs![currentIndex] {
            WorkoutStartController.coreDataConnection.deleteDataObject(entry)
        }
        
        logs![currentIndex] = WorkoutStartController.coreDataConnection.newLogbookEntryFromWorkoutSequence(workoutSequence![currentIndex])
        skipped![currentIndex] = nil
        
        setButtonColor()
        updateViewFromExercise()
    }
    
    @IBAction func nextButtonPressed() {
        commitForm();
        
        if (currentIndex == workoutSequence!.count - 1) {
            currentIndex = 0
        }
        else {
            currentIndex = currentIndex + 1
        }
        
        loadForm()
    }
    
    @IBAction func previousButtonPressed() {
        commitForm();
        
        if (currentIndex == 0) {
            currentIndex = workoutSequence!.count - 1
        }
        else {
            currentIndex = currentIndex - 1
        }
        
        loadForm()
    }
    
    func loadForm () {
        currentExercise = workoutSequence![currentIndex].exercise
        updateViewFromExercise();
        
    }
    
    func commitForm () {
        
        if currentExercise is ResistanceExercise {
            
            let exercise = currentExercise as! ResistanceExercise
            exercise.weight = slot1New.stringValue
            exercise.reps = slot2New.stringValue
            exercise.sets = slot3New.stringValue

        }
        else if currentExercise is CardioExercise {
        
            let exercise = currentExercise as! CardioExercise
            exercise.pace = slot1New.stringValue
            exercise.duration = slot2New.stringValue
            exercise.distance = slot3New.stringValue

        }
        
        WKInterfaceController.openParentApplication(["orderNumber": ""] , reply: { (reply, error) -> Void in});
    }
    
    func updateViewFromExercise () {
        
        if currentExercise is ResistanceExercise {
            let obj = currentExercise as! ResistanceExercise
            slot1 = (obj.weight as NSString).floatValue
            slot2 = (obj.reps as NSString).floatValue
            slot3 = (obj.sets as NSString).floatValue
            slot1New = (obj.weight as NSString).floatValue
            slot2New = (obj.reps as NSString).floatValue
            slot3New = (obj.sets as NSString).floatValue
            
            slot1Text = "weight";
            slot2Text = "reps";
            slot3Text = "sets";
            
            slot1Increment = (FitBuddyUtils.getSharedUserDefaults()?.objectForKey(FBConstants.kRESISTANCEINCKEY) as! NSString).floatValue
            slot2Increment = 1
            slot3Increment = 1
            
        }
        else if currentExercise is CardioExercise {
            let obj = currentExercise as! CardioExercise
            slot1 = (obj.pace as NSString).floatValue
            slot2 = (obj.duration as NSString).floatValue
            slot3 = (obj.distance as NSString).floatValue
            slot1New = (obj.pace as NSString).floatValue
            slot2New = (obj.duration as NSString).floatValue
            slot3New = (obj.distance as NSString).floatValue
            
            slot1Text = "pace";  //distance/duration
            slot2Text = "duration";
            slot3Text = "distance"; //pace * duration
            
            slot1Increment = (FitBuddyUtils.getSharedUserDefaults()?.objectForKey(FBConstants.kCARDIOINCKEY) as! NSString).floatValue
            slot2Increment = 1
            slot3Increment = (FitBuddyUtils.getSharedUserDefaults()?.objectForKey(FBConstants.kCARDIOINCKEY) as! NSString).floatValue
        }
        
        exerciseName = currentExercise!.name
        exerciseNameLabel.setText(exerciseName as String);
        updateExerciseDescription()
        
        slot1Label.setText(slot1Text as String);
        slot1Value.setText(slot1.stringValue);
        slot2Label.setText(slot2Text as String);
        slot2Value.setText(slot2.stringValue);
        slot3Label.setText(slot3Text as String);
        slot3Value.setText(slot3.stringValue);
        
        changeSliderColor(slot1Slider, value: 0.0)
        changeSliderColor(slot2Slider, value: 0.0)
        changeSliderColor(slot3Slider, value: 0.0)
        
        slot1Slider.setValue(0.0)
        slot2Slider.setValue(0.0)
        slot3Slider.setValue(0.0)
        
        setButtonColor()
    }
    
    func setButtonColor () {
        
        if let yellow = skipped![currentIndex] {
            skipButton.setBackgroundColor(FBConstants.WKORANGE)
        } else {
            skipButton.setBackgroundColor(FBConstants.WKGRAY);
        }
        
        if let green = logs![currentIndex] {
            logButton.setBackgroundColor(FBConstants.WKGREEN)
        } else {
            logButton.setBackgroundColor(FBConstants.WKGRAY);
        }
    }
    
    func updateExerciseDescription () {
        let label = slot1New.stringValue + " - " + slot2New.stringValue + " - " + slot3New.stringValue
        exerciseDescriptionLabel.setText(label);
    }
    
    func changeSliderColor (slider:WKInterfaceSlider, value:Float) {
        
        if value == 0 {
            slider.setColor(FBConstants.WKGRAY);
        }
        
        if value > 0 {
            slider.setColor(FBConstants.WKGREEN);
        }
        
        if value < 0 {
            slider.setColor(FBConstants.WKORANGE);
        }

        
    }
    
    
}
