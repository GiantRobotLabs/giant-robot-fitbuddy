//
//  LogbookViewController.swift
//  FitBuddy
//
//  Created by john.neyer on 5/14/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import FitBuddyModel
import UIKit
import FitBuddyCommon

class LogbookViewController2 : CoreDataTableController {
    
    var loggedWorkouts: NSMutableDictionary? = nil
    
    var logbookEntry : LogbookEntry? = nil
    @IBOutlet weak var chartView: UIView!
    
    var chart : JBBarChartView?
    var chartDataSource: NSArray?
    var entries : NSMutableArray?
    var chartData : BarChartDataSource?
    var frameLoaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named:FBConstants.kFITBUDDY))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupFetchedResultsController", name: FBConstants.kUBIQUITYCHANGED, object: nil)
    }
    
    func setupFetchedResultsController () {
        let request = NSFetchRequest(entityName: FBConstants.LOGBOOK_TABLE)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false, selector: "compare:")]
        request.predicate = NSPredicate(format: "completed = %@", argumentArray: [1])
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AppDelegate.sharedAppDelegate().managedObjectContext!, sectionNameKeyPath: "date_t", cacheName: nil)
    }
    
    func loadData () {
        //loggedWorkouts = AppDelegate.sharedAppDelegate().modelManager.getLogbookWorkoutsByDate ()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupFetchedResultsController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if chartData == nil
        {
            chartData = BarChartDataSource()
        }
        
        chartData!.load()
        self.prepareChart()
        chart!.reloadData()
        
        var footerFrame = chart!.footerView.frame
        footerFrame.origin.y = footerFrame.origin.y + 20
        chart!.footerView.frame = footerFrame
    }
    
    func prepareChart () {
        
        if chart == nil {
            chart = JBBarChartView()
            chart!.delegate = chartData
            chart!.dataSource = chartData
            
            self.addSubview(chart!, filingAndInsertedIntoView: self.chartView)
            
            // let headerView = UILabel(frame: CGRectMake(10.0f, cell(chart?.bounds.size.height * 0.5) - cell(80.0f * 0.5), chart?.bounds.size.width - (10.0f * 2), 80.0f))
            let headerView = UILabel(frame: CGRectMake(0, 0, 200, 14))
            
            headerView.text = "30 Day Activity Profile".uppercaseString
            headerView.textAlignment = NSTextAlignment.Center
            headerView.textColor = FBConstants.kCOLOR_DKGRAY
            headerView.font = UIFont(name: headerView.font.fontName, size: 14.0)
            chart!.headerView = headerView;
            
            chart!.headerPadding = 10.0
            
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "dd MMM yyyy"
            let rightDate = dateFormat.stringFromDate(NSDate())
            
            //let rightLabel = UILabel(frame: CGRectMake(20.0, 400, chart.bound.size.width = (10.0*2), 40.0))
            let rightLabel = UILabel(frame: CGRectMake(0, 0, 200, 12))
            rightLabel.text = rightDate.uppercaseString
            rightLabel.textAlignment = NSTextAlignment.Right
            rightLabel.textColor = UIColor.blackColor()
            rightLabel.font = UIFont(name: rightLabel.font.fontName, size: 12.0)
            chart?.footerView = rightLabel
            
            chart?.layoutIfNeeded()
            
        }
    }
    
    func addSubview (insertedView: UIView, filingAndInsertedIntoView containerView: UIView) {
        
        containerView.addSubview(insertedView)
        insertedView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": insertedView]))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[insertedView]|", options:NSLayoutFormatOptions.DirectionLeftToRight ,metrics: nil, views: ["insertedView": insertedView]))
        containerView.layoutIfNeeded()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Logbook Cell") as! UITableViewCell
        let exerciseLabel = cell.viewWithTag(100) as! UILabel
        let workoutLabel = cell.viewWithTag(101) as! UILabel
        let exerciseIcon = cell.viewWithTag(102) as! UIImageView
        let qstatValue = cell.viewWithTag(103) as! UILabel
        let qstatLabel = cell.viewWithTag(104) as! UILabel
        
        
        let logbookEntry = self.fetchedResultsController.objectAtIndexPath(indexPath) as! LogbookEntry
        entries?.addObject(logbookEntry)
        
        exerciseLabel.text = logbookEntry.exercise_name
        workoutLabel.text = logbookEntry.workout_name
        
        if logbookEntry.pace != nil {
            exerciseIcon.image = UIImage(named: FBConstants.kCARDIO)
            qstatLabel.text = "Pace"
            qstatValue.text = logbookEntry.pace
        }
        else {
            exerciseIcon.image = UIImage(named: FBConstants.kRESISTANCE)
            qstatLabel.text = "Weight"
            qstatValue.text = logbookEntry.weight
        }
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let entry = self.fetchedResultsController.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as! LogbookEntry
        if segue.destinationViewController is LogbookEntryViewController {
            (segue.destinationViewController as! LogbookEntryViewController).logbookEntry = entry
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.editing = true
            let entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as! LogbookEntry
            AppDelegate.sharedAppDelegate().managedObjectContext!.deleteObject(entry)
            
        }
    }
    
    func convertRawToShortDateString(rawDateStr: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        let date = formatter.dateFromString(rawDateStr)
        
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.stringFromDate(date!)
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = self.tableView.headerViewForSection(section)
        
        if sectionTitle == nil {
            return nil
        }
        
        let labelView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40.0))
        labelView.backgroundColor = FBConstants.kCOLOR_LTGRAY
        labelView.autoresizesSubviews = false
        
        let label = UILabel(frame: CGRectMake(15, 5, tableView.frame.size.width, 40.0))
        label.font = UIFont.systemFontOfSize(14.0)
        label.text = self.convertRawToShortDateString(sectionTitle!.textLabel.text!)
        label.textColor = FBConstants.kCOLOR_DKGRAY
        
        labelView.addSubview(label)
        return labelView
        
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return nil
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 0
    }
    
    
}


    