//
//  CoreDataConnection.swift
//  FitBuddy
//
//  Created by john.neyer on 5/5/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import CoreData
import FitBuddyCommon

public class CoreDataConnection : NSObject {
    
    override
    public init() {
        
    }
    
    lazy public var theLocalStore: NSURL = {
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (paths[0] as! NSURL).URLByAppendingPathComponent("Database").URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        }()
    
    
    lazy public var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    
    lazy public var managedObjectModel: NSManagedObjectModel = {
        
        let modelBundle = NSBundle(identifier: "com.giantrobotlabs.FitBuddy.FitBuddyModel")
        
        let modelURL = modelBundle!.URLForResource("GymBuddyModel", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
        }()
    
    lazy public var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()

    
    lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
                
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let dbDirURL = (paths[0] as! NSURL).URLByAppendingPathComponent("Database")
        let storeURL = self.theLocalStore
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dbDirURL.path!))
        {
            var error: NSError? = nil
            NSFileManager.defaultManager().createDirectoryAtURL(dbDirURL, withIntermediateDirectories: false, attributes: nil, error: &error)
            
            if (error != nil)
            {
                NSLog("Unable to create directory for database: %@", error!)
            }
        }
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storeUrl = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Database").URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeWillChangeHandler", name:  NSPersistentStoreCoordinatorStoresWillChangeNotification, object: coordinator);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidChangeHandler" , name:  NSPersistentStoreCoordinatorStoresDidChangeNotification, object: coordinator);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidImportHandler" , name:  NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coordinator);
        
        return coordinator
        }()
    
    
    public func checkUpgradePath(upgradeFlag : Bool) -> Bool {
        
        let versionKey = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kAPPVERSIONKEY)
        
        if (versionKey != nil && versionKey != FBConstants.kAPPVERSION) {
            if (FBConstants.DEBUG) {
                NSLog("Migrating data for user")
            }
            
            if (upgradeFlag) {
                NSUserDefaults.standardUserDefaults().setObject(FBConstants.kAPPVERSION, forKey: FBConstants.kAPPVERSIONKEY)
            }
            
            if ((NSUserDefaults.standardUserDefaults().objectForKey(FBConstants.kEXPORTDBKEY)) != nil) {
                NSUserDefaults.standardUserDefaults().setObject("iTunes", forKey: FBConstants.kEXPORTDBKEY)
            }
        }
        
        return true
        
    }
    
    public func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
               
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    
}