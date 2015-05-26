//
//  LogbookChartData.swift
//  FitBuddy
//
//  Created by john.neyer on 5/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import FitBuddyModel

class LogbookChartData {
    
    // Bar height calculation:
    // total weight = sum of exercises (lbs * reps) / day
    // max =  max total weight over 30 days
    // bar height = %max = total weight/max
    
    var maxResistance = 0.0
    var maxDistance = 0.0
    var resistanceValues = [Double]()
    var cardioValues = [Double]()
    var days = [String]()
    
    func setLogbookData(logbookEntries : [LogbookEntry]) {
        days = lastThirty()
        setValuesFromLogbookEntries(logbookEntries)
    }
    
    func getDayStringAtIndex (index : Int) -> String {
        return days[index]
    }
    
    func getResistanceAtIndex (index : Int) -> NSNumber {
        return NSNumber(double: resistanceValues[index]/maxResistance)
    }
    
    func getCardioAtIndex (index : Int) -> NSNumber {
        return NSNumber(double: cardioValues[index]/maxDistance)
    }
    
    func lastThirty() -> Array <String> {
        
        let cal = NSCalendar.currentCalendar()
        
        // start with today
        var date = cal.startOfDayForDate(NSDate())
        
        var days = [String]()
        
        for i in 1 ... 30 {
            // get day string component:
            days.append(dayStringFromDate(date))
            
            // move back in time by one day:
            date = cal.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: date, options: nil)!
        }
        return days.reverse()
    }
    
    func normalizedResistanceArray() -> Array<Double> {
        
        var normalized = [Double]()
        
        for value in resistanceValues {
           normalized.append((value/maxResistance) * 0.8)
        }
        
        return normalized
    }
    
    func normalizedCardioArray() -> Array<Double> {
        
        var normalized = [Double]()
        
        for value in cardioValues {
            normalized.append((value/maxDistance) * 0.75)
        }
        
        return normalized
    }
    
    private func setValuesFromLogbookEntries(entries : [LogbookEntry]) {
        
        resetData()
        var lastDate : NSDate?
        
        for entry in entries {
            
            if let i = find(days, dayStringFromDate(entry.date)) {
                
                if entry.weight != nil && entry.reps != nil && entry.sets != nil {
                    let resistance = ((entry.weight! as NSString).doubleValue * (entry.reps! as NSString).doubleValue * (entry.sets! as NSString).doubleValue)
                    resistanceValues[i] = resistanceValues[i] + resistance
                }
                else if entry.pace != nil && entry.duration != nil {
                    let cardio = ((entry.pace! as NSString).doubleValue * (entry.duration! as NSString).doubleValue)
                    cardioValues[i] = cardioValues[i] + cardio
                }
                
                if lastDate != entry.date {
                    
                    // Set Max
                    if resistanceValues[i] > maxResistance {
                        maxResistance = resistanceValues[i]
                    }
                    
                    if cardioValues[i] > maxDistance {
                        maxDistance = cardioValues[i]
                    }
                }
                
                lastDate = entry.date
                
            }
            else {
                break
            }
        }
    }
    
    private func dayStringFromDate (date : NSDate) -> String {
        let cal = NSCalendar.currentCalendar()
        let day = cal.component(.CalendarUnitDay, fromDate: date)
        let month = cal.component(.CalendarUnitMonth , fromDate: date)
        return String(month) + "/" + String(day)
    }
    
    private func resetData() {
        maxResistance = 1.0
        maxDistance = 1.0
        resistanceValues = [Double](count: 30, repeatedValue: 0.0)
        cardioValues = [Double](count:30, repeatedValue: 0.0)
    }
}