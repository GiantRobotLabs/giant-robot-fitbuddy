//
//  GymBuddyAppDelegate.m
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "GymBuddyAppDelegate.h"
#import "CoreDataHelper.h"
#import "GymBuddyMacros.h"

@implementation GymBuddyAppDelegate

@synthesize window = _window;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize ubiquityStoreManager = _ubiquityStoreManager;

+ (GymBuddyAppDelegate *)sharedAppDelegate {
    
    return (GymBuddyAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSManagedObjectContext *) sharedContext {
    return [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initStore];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:TRUE];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"titlebar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];

    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:222.0/255.0 green:11.0/255.0 blue:25.0/255.0 alpha:1]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark UbiquityStoreManager
- (void) initStore
{
    // STEP 1 - Initialize the store
    NSLog( @"Starting UbiquityStoreManagerExample on device: %@\n\n", [UIDevice currentDevice].name );
    
    [CoreDataHelper copyiCloudtoLocal];
    
    NSURL *dirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    dirUrl = [dirUrl URLByAppendingPathComponent:UBIQUITYDB];
    
    
    //STEP 1 - Initialize the UbiquityStoreManager
    _ubiquityStoreManager = [[UbiquityStoreManager alloc] initStoreNamed:UBIQUITYDB withManagedObjectModel:nil localStoreURL:nil containerIdentifier:nil storeConfiguration:nil storeOptions:nil delegate:self];
    
    [_ubiquityStoreManager migrateLocalToCloud];
   
}

- (void)ubiquityStoreManager:(UbiquityStoreManager *)manager willLoadStoreIsCloud:(BOOL)isCloudStore {
    
    self.managedObjectContext = nil;
}

- (void)ubiquityStoreManager:(UbiquityStoreManager *)manager didLoadStoreForCoordinator:(NSPersistentStoreCoordinator *)coordinator isCloud:(BOOL)isCloudStore {
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    [self.managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}

@end
