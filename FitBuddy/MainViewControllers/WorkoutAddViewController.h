//
//  WorkoutAddViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"
#import "Workout.h"
#import "Exercise.h"

#import "GymBuddyMacros.h"

@interface WorkoutAddViewController : CoreDataTableController

@property (nonatomic, weak) IBOutlet UITextField *workoutNameTextField;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) NSMutableOrderedSet *workoutSet;

@property (nonatomic, strong) UIManagedDocument *document;

-(IBAction) checkboxClicked:(id) sender;

@end
