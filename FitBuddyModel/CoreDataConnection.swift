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

@objc
public class CoreDataConnection : NSObject {
    
    //The default context
    static public let defaultConnection : CoreDataConnection = CoreDataConnection()
    
    override
    public init() {
        
    }
    
    public init(groupContext: Bool) {
        super.init()
        
        if groupContext {
            self.setGroupContext()
        }
    }
    
    lazy public var theLocalStore: NSURL = {
        return CoreDataHelper2.coreDataLocalURL()
        }()
    
    
    lazy public var applicationDocumentsDirectory: NSURL = {
        return CoreDataHelper2.localDocsURL()
        }()
    
    
    lazy public var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: NSBundle(identifier: "com.giantrobotlabs.FitBuddy.FitBuddyModel")!.URLForResource("GymBuddyModel", withExtension: "momd")!)!
        }()
    
    lazy public var managedObjectContext: NSManagedObjectContext = {
        
        let managedObjectContext = NSManagedObjectContext()
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType);
        
        return managedObjectContext
        }()

    
    lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       
        let path = self.applicationDocumentsDirectory
        let dbDirURL = path.URLByAppendingPathComponent("Database")
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
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        let options = self.defaultStoreOptions()
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.theLocalStore, options: options, error: &error) == nil {
            
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeWillChangeHandler", name:  NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidChangeHandler" , name:  NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storeDidImportHandler" , name:  NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: nil);
        
        return coordinator!
        }()
    
    public func defaultStoreOptions () -> [NSObject: AnyObject]? {
        
        var icloudDefault = false
        if let sharedDefaults = NSUserDefaults(suiteName: FBConstants.kGROUPPATH) {
            icloudDefault = NSUserDefaults(suiteName: FBConstants.kGROUPPATH)!.boolForKey(FBConstants.kUSEICLOUDKEY)
        }
    
        return defaultStoreOptions(icloudDefault)
    }
    
    public func defaultStoreOptions (foriCloud: Bool) -> [NSObject: AnyObject]? {
        
        if foriCloud {
            return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true, NSPersistentStoreUbiquitousContentNameKey: "iCloudStore"]
        }
        
        return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    }
        
    //Set app directory and local store to the group container. 
    //This will move files if the group container hasn't been initialized.
    public func setGroupContext () -> Bool {
        
        if !(NSFileManager.defaultManager().fileExistsAtPath(CoreDataHelper2.coreDataGroupURL().path!)) {
            
            let groupDBDir = CoreDataHelper2.groupDocsURL().URLByAppendingPathComponent("Database")
            let groupDBPath = CoreDataHelper2.coreDataGroupURL()
            
            let appDBDir = CoreDataHelper2.localDocsURL().URLByAppendingPathComponent("Database")
            let appDBPath = CoreDataHelper2.coreDataLocalURL()
            
            moveFiles(appDBDir, toDir: groupDBDir)
        }
        else if NSFileManager.defaultManager().fileExistsAtPath(CoreDataHelper2.coreDataLocalURL().path!) {
            CoreDataHelper2.migrateDataStore(CoreDataHelper2.coreDataLocalURL(), sourceStoreType: CoreDataType.LOCAL, destSqliteStore: CoreDataHelper2.coreDataGroupURL(), destStoreType: CoreDataType.GROUP)
        }
        
        self.applicationDocumentsDirectory = CoreDataHelper2.groupDocsURL()
        self.theLocalStore = CoreDataHelper2.coreDataGroupURL()
    
        NSLog("Set up group context")
        
        return true
    }
    
    public func setUbiquityContext () -> Bool {
        
        if FitBuddyUtils.isCloudOn() == (CoreDataHelper2.coreDataUbiquityURL() != nil) {
            //This is good. Cloud settings are in sync
            
            if FitBuddyUtils.isCloudOn() {
                //Need to set doc locations to device for sync
                self.applicationDocumentsDirectory = CoreDataHelper2.localDocsURL()
                self.theLocalStore = CoreDataHelper2.coreDataUbiquityURL()!
            }
        }
        else if FitBuddyUtils.isCloudOn() && (CoreDataHelper2.coreDataUbiquityURL() == nil) {
            //This means someone turned off iCloud. Need to rebuild the database and remove ubiquity keys
            NSLog("%@ %@", FitBuddyUtils.isCloudOn(), (CoreDataHelper2.coreDataUbiquityURL() == nil))
            
            CoreDataHelper2.migrateDataStore(CoreDataHelper2.coreDataLocalURL(), sourceStoreType: CoreDataType.ICLOUD, destSqliteStore: CoreDataHelper2.coreDataGroupURL(), destStoreType: CoreDataType.GROUP)
            
            FitBuddyUtils.setCloudOn(false)
        }
        else if CoreDataHelper2.coreDataUbiquityURL() != nil && !FitBuddyUtils.isCloudOn() {
            //This means iCloud was just turned on. Time to migrate to ubiquity store.
            NSLog("%@ %@", (CoreDataHelper2.coreDataUbiquityURL() != nil), (!FitBuddyUtils.isCloudOn()))
            NSLog("Not setting up cloud sync for now. Leaving data in the group.")
            
            /*
            //First make sure we're in group
            setGroupContext()
            
            //Now migrate the copy
            CoreDataHelper2.migrateDataStore(CoreDataHelper2.coreDataGroupURL(), sourceStoreType: CoreDataType.GROUP, destSqliteStore: CoreDataHelper2.coreDataUbiquityURL()!, destStoreType: CoreDataType.ICLOUD)
            */
        }

        return true
    }
    
    func moveFiles(fromDir: NSURL, toDir: NSURL) {
        
        var error: NSError? = nil
        
        //Make sure the local exists for copy
        if !NSFileManager.defaultManager().fileExistsAtPath(toDir.path!) {
            NSFileManager.defaultManager().createDirectoryAtPath(toDir.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
        }
        
        let directoryEnumerator = NSFileManager.defaultManager().enumeratorAtPath(fromDir.path!)
        
        while let file = directoryEnumerator?.nextObject() as? String {
            
            if let fileUrl = NSURL(fileURLWithPath: file) {
                
                if NSFileManager.defaultManager().copyItemAtPath(fromDir.URLByAppendingPathComponent(file).path!, toPath: toDir.URLByAppendingPathComponent(fileUrl.lastPathComponent!).path!, error: &error) {
                }
                
                NSFileManager.defaultManager().removeItemAtPath(fromDir.URLByAppendingPathComponent(file).path!, error: &error)
            }
        }
        
        if error != nil {
            NSLog("Unable to move database to app container: %@", error!)
        }
    }
    
/////
//
// Change handlers for the UbiquityStoreManager
//
    public func storeWillChangeHandler() {
        
        
        if (FBConstants.DEBUG) {
            NSLog("Saving context prior to change.")
        }
        
        var error: NSError? = nil
        self.managedObjectContext.save(&error)
        self.managedObjectContext.reset();
        
        if (error != nil) {
            NSLog("Error occured while saving context during prepare: %@", error!)
        }
        
    }
    
    public func storeDidChangeHandler () {
        
        var error: NSError? = nil
        self.managedObjectContext.save(&error)
        
        if (error != nil) {
            NSLog("Error occured while saving context on change: %@", error!)
        }
        
        if (FBConstants.DEBUG) {
            NSLog("Store did change. Notify listeners");
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
        
    }
    
    public func storeDidImportHandler() {
        
        
        
        var error: NSError? = nil
        
        if (FBConstants.DEBUG) {
            NSLog("Store did change on import. Notify listeners")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
    }
    
}