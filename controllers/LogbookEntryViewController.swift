//
//  LogbookEntryViewController.swift
//  FitBuddy
//
//  Created by john.neyer on 5/16/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import FitBuddyModel
import FitBuddyCommon

class LogbookEntryViewController: UIViewController {
    
    var logbookEntry: LogbookEntry? = nil
    
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryName: UILabel!
    @IBOutlet weak var slotOneLabel: UILabel!
    @IBOutlet weak var slotTwoLabel: UILabel!
    @IBOutlet weak var slotThreeLabel: UILabel!
    @IBOutlet weak var colOneDate: UILabel!
    @IBOutlet weak var colTwoDate: UILabel!
    @IBOutlet weak var slotOneColOne: UILabel!
    @IBOutlet weak var slotTwoColOne: UILabel!
    @IBOutlet weak var slotThreeColOne: UILabel!
    @IBOutlet weak var slotOneColTwo: UILabel!
    @IBOutlet weak var slotTwoColTwo: UILabel!
    @IBOutlet weak var slotThreeColTwo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: FBConstants.kFITBUDDY))
    }
    
    func loadFormDataFromLogbook () {
        
        // Set the data
        self.entryDate.text = FitBuddyUtils.dateFromNSDate(self.logbookEntry!.date, format: "dd MMM yyyy")
        self.entryName.text = self.logbookEntry!.exercise_name
        
        if !self.logbookEntry!.pace!.isEmpty {
            self.slotOneLabel.text = "Pace"
            self.slotOneColOne.text = self.logbookEntry!.pace
            
            self.slotTwoLabel.text = "Duration"
            self.slotTwoColOne.text = self.logbookEntry!.duration
            
            self.slotThreeLabel.text = "Distance"
            self.slotThreeColOne.text = self.logbookEntry!.distance
        }
        else
        {
            self.slotOneLabel.text = "Weight"
            self.slotOneColOne.text = self.logbookEntry!.weight
        
            self.slotTwoLabel.text = "Sets"
            self.slotTwoColOne.text = self.logbookEntry!.sets
            
            self.slotThreeLabel.text = "Reps"
            self.slotThreeColOne.text = self.logbookEntry!.reps
        }
        
        self.colOneDate.text = FitBuddyUtils.shortDateFromNSDate(self.logbookEntry!.date)
        
    }
    
    
    func loadLastEntryFromLogbook () {
        
        let exerciseName = self.logbookEntry!.exercise_name
        let entryDate = self.logbookEntry!.date.copy() as! NSDate
        
        let request = NSFetchRequest(entityName: FBConstants.LOGBOOK_TABLE)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "(exercise_name = %@) AND (date < %@) AND (completed = %@)", argumentArray: [exerciseName, entryDate, 1])
        
        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AppDelegate.sharedAppDelegate().managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        var error: NSError? = nil
        frc.performFetch(&error)
        
        NSLog("Retrieving logbook")
        let array = frc.fetchedObjects
        
        var theEntry: LogbookEntry?
        
        if array != nil && array?.count > 0 {
            
            theEntry = (array!.last as! LogbookEntry)
            
            self.colTwoDate.text = FitBuddyUtils.shortDateFromNSDate(theEntry?.date)
            
            if !theEntry!.pace!.isEmpty {
                self.slotOneColTwo.text = theEntry!.pace
                self.slotTwoColTwo.text = theEntry!.duration
                self.slotThreeColTwo.text = theEntry!.distance
            }
            else
            {
                self.slotOneColTwo.text = theEntry!.weight
                self.slotTwoColTwo.text = theEntry!.sets
                self.slotThreeColTwo.text = theEntry!.reps
            }
            
        }
        else
        {
            self.colTwoDate.text = "--/--/--"
            self.slotOneColTwo.text = "-"
            self.slotTwoColTwo.text = "-"
            self.slotThreeColTwo.text = "-"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadFormDataFromLogbook()
        self.loadLastEntryFromLogbook()
    }
    
}