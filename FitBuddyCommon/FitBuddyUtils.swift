//
//  FitBuddyUtils.swift
//  FitBuddy
//
//  Created by john.neyer on 5/7/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation


public class FitBuddyUtils {
    
    
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
    
}