//
//  FitBuddyUtils.swift
//  FitBuddy
//
//  Created by john.neyer on 5/7/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation

@objc
public class FitBuddyUtils {
    
    public static func dateFromNSDate (date: NSDate?, format: String) -> String {
        
        if date != nil {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = format
            
            return dateFormatter.stringFromDate(date!)
            
        }
        
        return ""
    }
    
    public static func shortDateFromNSDate (date: NSDate?) -> String {
        
        if date != nil {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            
            return dateFormatter.stringFromDate(date!)
            
        }
        
        return ""
    }
    
    public static func getSharedUserDefaults() -> NSUserDefaults? {
        
        return NSUserDefaults(suiteName: FBConstants.kGROUPPATH)
    
    }
    
    public static func twoDecimalFormat(number: NSNumber?) -> String? {
        
        if number != nil {
            
            let twodec = String(format: "%.2f", number!.floatValue)
            let newval = NSString(string: twodec).floatValue * 1.0
            return NSNumber(float: newval).stringValue
        }
        
        return nil
    }
    
    public static func calculateDistance(pace: Float, minutes: Float) -> Float {
        if minutes > 0 {
            let value = pace * (minutes / 60.0)
            let str = NSString(format: "%.2f", value)
            return str.floatValue
        }
        
        return 0
    }
    
    public static func calculatePace(distance: Float, minutes: Float) -> Float {
        
        if minutes > 0 {
            let value = distance / (minutes / 60.0)
            let str = NSString(format: "%.2f", value)
            return str.floatValue
        }
        
        return 0
    }
    
    public static func calculateMinutes(pace: Float, distance:Float) -> Float {
        
        if (pace > 0) {
            let value = (distance / pace) * 60.0
            let str = NSString(format: "%.2f", value)
            return str.floatValue
        }
        
        return 0

    }
    
    public static func isCloudOn() -> Bool {
        let cloud = FitBuddyUtils.getSharedUserDefaults()!.boolForKey(FBConstants.kUSEICLOUDKEY)
        return cloud
    }
    
    public static func setCloudOn(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: FBConstants.kUSEICLOUDKEY)
        NSUserDefaults.standardUserDefaults().synchronize()
        FitBuddyUtils.getSharedUserDefaults()!.setBool(value, forKey: FBConstants.kUSEICLOUDKEY)
        FitBuddyUtils.getSharedUserDefaults()!.synchronize()
    }
    
}