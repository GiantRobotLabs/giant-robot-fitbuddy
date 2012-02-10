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

@interface WorkoutAddViewController : CoreDataTableController

@property (weak, nonatomic) IBOutlet UITextField *workoutNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) Exercise *exercise;

@property (nonatomic, strong) UIManagedDocument *document;

@end
