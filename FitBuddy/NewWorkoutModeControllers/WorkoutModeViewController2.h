//
//  WorkoutModeViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseControlController.h"
#import "LogbookEntry.h"
#import "Workout.h"

@interface WorkoutModeViewController2 : ExerciseControlController

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;

// Database
@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (nonatomic, strong) Workout *workout;

// Initializers
-(void) initialSetupOfFormWithExercise:(Exercise *)exercise
                            andLogbook: (LogbookEntry *) logbookEntry
                            forWorkout: (Workout *) workout;
-(void) saveLogbookEntry;
-(void) setExerciseFromForm;


@property NSUInteger pageIndex;

@end
