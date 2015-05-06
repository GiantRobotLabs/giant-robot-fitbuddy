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
import FitBuddyCommon
import FitBuddyModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static func sharedAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate;
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        self.coreDataConnection.checkUpgradePath(CoreDataHelper.migrateDataToSqlite())
        //self.coreDataConnection.configureGroupContainter()
        
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
    
    lazy var coreDataConnection : CoreDataConnection = {
        return CoreDataConnection()
        }()
    
    lazy var theLocalStore: NSURL = {
        return self.coreDataConnection.theLocalStore
        }()

    lazy var applicationDocumentsDirectory: NSURL = {
        return self.coreDataConnection.applicationDocumentsDirectory
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return self.coreDataConnection.managedObjectModel
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        return self.coreDataConnection.persistentStoreCoordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        return self.coreDataConnection.managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        coreDataConnection.saveContext()
    }
    
    func checkUpgradePath(upgradeFlag : Bool) -> Bool {
        return coreDataConnection.checkUpgradePath(upgradeFlag)
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
