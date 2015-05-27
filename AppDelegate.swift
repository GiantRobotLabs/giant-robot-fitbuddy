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
@objc
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static func sharedAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate;
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        self.coreDataConnection.setGroupContext()
        self.coreDataConnection.setUbiquityContext()
    
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
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        self.syncSharedDefaults()
        
        if FitBuddyUtils.isCloudOn() {
            CoreDataHelper2.migrateiCloudStoreToGroupStore()
        }
        
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
    lazy var modelManager : ModelManager = {
        return CoreDataModelManager(connection: self.coreDataConnection)
        }()
    
    lazy var coreDataConnection : CoreDataConnection = {
        return CoreDataConnection.defaultConnection
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
    
    func saveContext () {
        self.modelManager.save()
    }
    
    func syncSharedDefaults() {
        
        if let shareDefaults = FitBuddyUtils.defaultUtils().sharedUserDefaults {
            
            if let resistance = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kRESISTANCEINCKEY) {
                shareDefaults.setObject(resistance, forKey: FBConstants.kRESISTANCEINCKEY)
            }
            else {
                shareDefaults.setObject("2.5", forKey: FBConstants.kRESISTANCEINCKEY)
            }
            
            if let cardio = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kCARDIOINCKEY) {
                shareDefaults.setObject(cardio, forKey: FBConstants.kCARDIOINCKEY)
            }
            else {
                shareDefaults.setObject("0.5", forKey: FBConstants.kCARDIOINCKEY)
            }
            
            if let icloud = NSUserDefaults.standardUserDefaults().stringForKey(FBConstants.kUSEICLOUDKEY) {
                shareDefaults.setObject(icloud, forKey: FBConstants.kUSEICLOUDKEY)
            }
            
            shareDefaults.synchronize()
            
        }
        else {
            NSLog("Could not sync defaults")
        }
    
    }
}
