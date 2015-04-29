//
//  InterfaceController.swift
//  FitBuddy WatchKit Extension
//
//  Created by john.neyer on 4/25/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import WatchKit
import Foundation

class WorkoutInterfaceController: WKInterfaceController {

    var exerciseName: NSString = "";
    var exerciseDescription: NSString = "";
    
    var slot1: Float = 0.0;
    var slot2: Float = 0.0;
    var slot3: Float = 0.0;
    
    var slot1Text: NSString = "";
    var slot2Text: NSString = "";
    var slot3Text: NSString = "";
    
    let green: UIColor = UIColor.greenColor();
    let orange: UIColor = UIColor.orangeColor();
    let gray: UIColor = UIColor.lightGrayColor();
    
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
    
    
    func initView () {
        
        exerciseNameLabel.setText(exerciseName as String);
        exerciseDescriptionLabel.setText(exerciseDescription as String);
        
        slot1Label.setText(slot1Text as String);
        slot1Value.setText(NSNumber(float: slot1).stringValue);
        slot2Label.setText(slot2Text as String);
        slot2Value.setText(NSNumber(float: slot2).stringValue);
        slot3Label.setText(slot3Text as String);
        slot3Value.setText(NSNumber(float: slot3).stringValue);
        
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        slot1 = 100.0;
        slot2 = 12;
        slot3 = 3;
        
        slot1Text = "weight";
        slot2Text = "reps";
        slot3Text = "sets";
        
        exerciseName = "exercise name";
        exerciseDescription = "999.99 - 99 - 99";
        
       
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        initView();
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func changeSlot1(value: Float) {
        let display: NSNumber = NSNumber(float: slot1 + value);
        slot1Value.setText(display.stringValue);
        
        changeSliderColor(slot1Slider, value: value);
        
    }
    
    @IBAction func changeSlot2(value: Float) {
        let display: NSNumber = NSNumber(float: slot2 + value);
        slot2Value.setText(display.stringValue);
        
        changeSliderColor(slot2Slider, value: value);
    }

    @IBAction func changeSlot3(value: Float) {
        let display: NSNumber = NSNumber(float: slot3 + value);
        slot3Value.setText(display.stringValue);
        
        changeSliderColor(slot3Slider, value: value);
    }
    

    @IBAction func skipButtonPressed() {
        skipButton.setBackgroundColor(orange);
        logButton.setBackgroundColor(gray);
    }
    
    
    @IBAction func logButtonPressed() {
        logButton.setBackgroundColor(green);
        skipButton.setBackgroundColor(gray);
        
    }
    
    @IBAction func nextButtonPressed() {
        commitForm();  
    }
    
    @IBAction func previousButtonPressed() {
        commitForm();
    }
    
    func commitForm () {
        WKInterfaceController.openParentApplication(["orderNumber": ""] , reply: { (reply, error) -> Void in});
    }
    
    
    func changeSliderColor (slider:WKInterfaceSlider, value:Float) {
        
        if value == 0 {
            slider.setColor(gray);
        }
        
        if value > 0 {
            slider.setColor(green);
        }
        
        if value < 0 {
            slider.setColor(orange);
        }

        
    }
    
    
}
