//
//  LogbookEntry_TDate.swift
//  FitBuddy
//
//  Created by John Neyer on 4/29/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation


extension LogbookEntry {
    
    func getDate_t() -> NSDate {
    
        let format: NSDateFormatter = NSDateFormatter.new()
        format.dateFormat = "dd MMM yyyy"
        let dateOnly = format.stringFromDate(self.date)
        return format.dateFromString(dateOnly)!
 
    }
    
}