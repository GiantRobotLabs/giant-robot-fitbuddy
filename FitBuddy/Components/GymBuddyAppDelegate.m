//
//  GymBuddyAppDelegate.m
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "GymBuddyAppDelegate.h"
#import "CoreDataHelper.h"

@implementation GymBuddyAppDelegate

@synthesize window = _window;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// Return static shared app delegate
+ (GymBuddyAppDelegate *)sharedAppDelegate {
    
    return (GymBuddyAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSURL *) theLocalStore {
    return [[[[GymBuddyAppDelegate sharedAppDelegate] applicationDocumentsDirectory] URLByAppendingPathComponent:@"Database"] URLByAppendingPathComponent:kDATABASE2_0];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkUpgradePath];

    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:TRUE];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:kTITLEBAR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundColor:kCOLOR_LTGRAY];

    [[UITabBar appearance] setTintColor:kCOLOR_RED];
    
    [[UIPageControl appearance] setPageIndicatorTintColor:kCOLOR_GRAY];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:kCOLOR_RED];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [self.managedObjectContext reset];
    [self.managedObjectContext save:&error];
}

static UIManagedDocument *olddb;

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GymBuddyModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *dbDirURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"Database"];
    NSURL *storeURL = [GymBuddyAppDelegate theLocalStore];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[dbDirURL path]])
    {
        NSError *err;
        [[NSFileManager defaultManager] createDirectoryAtURL:dbDirURL withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (err)
        {
            NSLog(@"Unable to create directory for database: %@", err);
        }
    }
    
    NSLog(@"[storeURL path]=%@",[storeURL path]);
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
                              NSPersistentStoreUbiquitousContentNameKey : @"iCloudStore"};
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeWillChangeHandler:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDidChangeHandler:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDidImportHandler:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:_persistentStoreCoordinator];
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Upgrades

-(BOOL) checkUpgradePath
{
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kAPPVERSIONKEY] isEqualToString:kAPPVERSION])
    {
        if (DEBUG) NSLog(@"Migrating data for user");
        if ([CoreDataHelper migrateDataToSqlite])
        {
            [[NSUserDefaults standardUserDefaults] setObject:kAPPVERSION forKey:kAPPVERSIONKEY];
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kEXPORTDBKEY])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"iTunes" forKey:kEXPORTDBKEY];
    }
    
 //   if (![[[NSUserDefaults standardUserDefaults] objectForKey:kDBVERSIONKEY] isEqualToString:kDBVERSION])
 //   {
 //       if (DEBUG) NSLog(@"Building version data for user");
 //       if ([CoreDataHelper createChartHistory])
 //       {
 //           [[NSUserDefaults standardUserDefaults] setObject:kDBVERSION forKey:kDBVERSIONKEY];
 //       }
 //   }
    
    return TRUE;
}

- (void) storeWillChangeHandler: (id) sender
{
    if (_managedObjectContext)
    {
        if (DEBUG) NSLog(@"Saving context prior to change.");
        
        NSError *err;
        [_managedObjectContext save:&err];
        [_managedObjectContext reset];
        
        if (err)
        {
            NSLog(@"Error occured while saving context during prepare: %@", err);
        }
        
    }
    
}

-(void) storeDidChangeHandler: (id) sender
{
    if (_managedObjectContext)
    {
        NSError *err;
        
        [_managedObjectContext save:&err];
        
        if (err)
        {
            NSLog(@"Error occured while saving context on change: %@", err);
        }
        
        if (DEBUG) NSLog(@"Store did change. Notify listeners");
       
        [[NSNotificationCenter defaultCenter] postNotificationName:kUBIQUITYCHANGED object:self];
        
    }
    
}

-(void) storeDidImportHandler: (id) sender
{
    if (_managedObjectContext)
    {
        NSError *err;
        
        if (err)
        {
            NSLog(@"Error occured while merging context on change: %@", err);
        }
        
        if (DEBUG) NSLog(@"Store did change on import. Notify listeners");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUBIQUITYCHANGED object:self];
        
    }
    
}

@end
