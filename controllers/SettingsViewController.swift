//
//  SettingsViewController.swift
//  FitBuddy
//
//  Created by John Neyer on 5/11/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import FitBuddyCommon

var data: NSArray = []
let defaults = FitBuddyUtils.defaultUtils().sharedUserDefaults

class SettingsViewController: UITableViewController {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func loadTableFromDefaults() {
        
        for cell : UITableViewCell in tableView.visibleCells() as! [UITableViewCell] {
            let label = cell.viewWithTag(100) as! UILabel
            let detail = cell.viewWithTag(200) as? UILabel
            
            if let value = defaults!.stringForKey(label.text!) {
                detail!.text = value
            }
            else {
                if label.text == FBConstants.kRESISTANCEINCKEY {
                    detail!.text = "2.5"
                }
                else if label.text == FBConstants.kCARDIOINCKEY {
                    detail!.text = "0.5"
                }
                else if label.text == FBConstants.kEXPORTDBKEY {
                    detail!.text = "iTunes"
                }
                else if label.text == FBConstants.kUSEICLOUDKEY {
                    detail!.text = "No"
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
   
    override
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTableFromDefaults()
    }
    
    override
    func viewDidLoad() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: FBConstants.kFITBUDDY))
    }
    
    override
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == FBConstants.SETTINGS_SEGUE {
        
            let setDefaultsKey = Selector("setDefaultsKey")
            
            if segue.destinationViewController is SettingsIncrementViewController {
                
                let label = (sender as! UITableViewCell).viewWithTag(100) as! UILabel
                (segue.destinationViewController as! SettingsIncrementViewController).settingsKey = label.text
                
                let pickerValues = NSMutableArray()
                let detail = (sender as! UITableViewCell).viewWithTag(200) as! UILabel
                
                if label.text!.hasSuffix(FBConstants.kCARDIOINCKEY) {
                    pickerValues.addObjectsFromArray(FBConstants.kDEFAULT_CARDIO_SETTINGS)
                }
                else if  label.text!.hasSuffix(FBConstants.kRESISTANCEINCKEY) {
                    pickerValues.addObjectsFromArray(FBConstants.kDEFAULT_RESISTANCE_SETTINGS)
                }
                else if label.text!.hasSuffix(FBConstants.kEXPORTDBKEY) {
                    pickerValues.addObjectsFromArray(FBConstants.kDEFAULT_EXPORT_TYPES)
                }
                else if label.text!.hasSuffix(FBConstants.kUSEICLOUDKEY) {
                    pickerValues.addObjectsFromArray(FBConstants.kDEFAULT_BOOLEAN_OPTIONS)
                }
                
                (segue.destinationViewController as! SettingsIncrementViewController).setPickerValues(pickerValues, defaultValue: detail.text!)
            }
        }
    }
    
    override
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let label = cell.viewWithTag(100) as! UILabel
            
            if label.text!.hasSuffix("Getting started") {
                self.performSegueWithIdentifier("Segue to Demo", sender: self)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        }
    }
    
    func addPickerValue(array: NSMutableArray, value: String) -> NSArray {
        
        if !array.containsObject(value) {
            array.addObject(value)
        }
    
        array.sortUsingComparator({
            (str1: AnyObject, str2: AnyObject) -> NSComparisonResult in
            return str1.compare(str2 as! String, options: NSStringCompareOptions.NumericSearch)
        } as! NSComparator)
        
        return array
    }
    
}