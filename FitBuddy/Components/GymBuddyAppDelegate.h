//
//  GymBuddyAppDelegate.h
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UbiquityStoreManager.h"

@interface GymBuddyAppDelegate : UIResponder <UIApplicationDelegate, UbiquityStoreManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UbiquityStoreManager *ubiquityStoreManager;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (GymBuddyAppDelegate *)sharedAppDelegate;
+ (NSManagedObjectContext *) sharedContext;

@end
