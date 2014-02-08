//
//  WorkoutViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"

#import "GymBuddyMacros.h"

@interface WorkoutViewController : CoreDataTableController

// Outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL edit;

-(void) enableButtons: (BOOL) enable;
-(void) initializeDefaults;

@end