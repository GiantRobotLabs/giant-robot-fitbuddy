//
//  GymBuddyViewController.h
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "Workout.h"
#import "CoreDataTableViewController.h"
#import "ExerciseControlController.h"

@interface ExerciseEditViewController : ExerciseControlController

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@end
