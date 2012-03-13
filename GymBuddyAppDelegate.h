//
//  GymBuddyAppDelegate.h
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GymBuddyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
