//
//  LogbookEntry_TDate.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation


extension LogbookEntry {
    
    class var date_t : NSDate {
    
        let format: NSDateFormatter = NSDateFormatter.new()
        format.dateFormat = "dd MMM yyyy"
        
        let dateOnly = format.stringFromDate(self.valueForKey("date") as! NSDate)
        return format.dateFromString(dateOnly)!
 
    }
    
}