//
//  AddExerciseViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface ExerciseAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addExerciseField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *exerciseTypeToggle;

@property (strong, nonatomic) NSMutableArray *exerciseArray;
@property (nonatomic, strong) NSMutableOrderedSet *workoutSet;

@end
