//
//  AppDelegate.swift
//  FitBuddy
//
//  Created by john.neyer on 4/26/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RealmData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static func theLocalStore() -> NSURL {
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (paths[0] as! NSURL).URLByAppendingPathComponent("Database").URLByAppendingPathComponent(FBConstants.kDATABASE2_0)
    }
    
    static func sharedAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate;
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        checkUpgradePath();
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: FBConstants.kTITLEBAR), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        UITabBar.appearance().backgroundColor = FBConstants.kCOLOR_GRAY
        UITabBar.appearance().tintColor = FBConstants.kCOLOR_RED
        
        UIPageControl.appearance().pageIndicatorTintColor = FBConstants.kCOLOR_GRAY
        UIPageControl.appearance().currentPageIndicatorTintColor = FBConstants.kCOLOR_RED
        UIPageControl.appearance().backgroundColor = UIColor.clearColor()
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        // Override point for customization after application launch.
        
        DataConnector().setupSharedData()
        
        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.giantrobotlabs.cd_single_template" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GymBuddyModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let dbDirURL = (paths[0] as! NSURL).URLByAppendingPathComponent("Database")
        let storeURL = AppDelegate.theLocalStore
        
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
    

    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func checkUpgradePath() -> Bool {
        
        let versionKey = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kAPPVERSIONKEY)
        
        if (versionKey != nil && versionKey != FBConstants.kAPPVERSION) {
            if (FBConstants.DEBUG) {
                NSLog("Migrating data for user")
            }
        
            if (CoreDataHelper.migrateDataToSqlite()) {
                NSUserDefaults.standardUserDefaults().setObject(FBConstants.kAPPVERSION, forKey: FBConstants.kAPPVERSIONKEY)
            }
            
            if ((NSUserDefaults.standardUserDefaults().objectForKey(FBConstants.kEXPORTDBKEY)) != nil) {
                NSUserDefaults.standardUserDefaults().setObject("iTunes", forKey: FBConstants.kEXPORTDBKEY)
            }
        }
        
        return true
        
    }
    
    
    func storeWillChangeHandler(sender: AnyObject) {
        
        if ((self.managedObjectContext) != nil) {
            if (FBConstants.DEBUG) {
                NSLog("Saving context prior to change.")
            }
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            self.managedObjectContext!.reset();
            
            if (error != nil) {
                NSLog("Error occured while saving context during prepare: %@", error!)
            }
            
        }
        
    }
    
    func storeDidChangeHandler (sender: AnyObject) {
        
        if (self.managedObjectContext != nil)  {
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            
            if (error != nil) {
                NSLog("Error occured while saving context on change: %@", error!)
            }
            
            if (FBConstants.DEBUG) {
                NSLog("Store did change. Notify listeners");
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
            
        }
        
        
    }
    
    func storeDidImportHandler(sender: AnyObject) {
        
        if (self.managedObjectContext != nil) {
            
            var error: NSError? = nil
            
            if (FBConstants.DEBUG) {
                NSLog("Store did change on import. Notify listeners")
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(FBConstants.kUBIQUITYCHANGED, object: self)
        }

    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        NSLog("watch button clicked");
        
        let alert = UIAlertView(title: "Watch button clicked", message: "You just touched the watch", delegate: nil, cancelButtonTitle: "OK")
        
        
    }
    
    
}
