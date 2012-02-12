//
//  ExerciseListTableViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Workout.h"

#import "GymBuddyMacros.h"

@interface ExerciseListTableViewController : CoreDataTableViewController

@property (strong, nonatomic) UIManagedDocument *document;
@property (nonatomic, strong) Workout *workout;

// Outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
