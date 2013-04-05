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

#import "GymBuddyMacros.h"

@interface WorkoutModeViewController : ExerciseControlController

// Outlets
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipitButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logitButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;

// Database
@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) NSOrderedSet *exercises;
@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (nonatomic, strong) NSMutableOrderedSet *logbookEntries;
@property (nonatomic, strong) NSMutableOrderedSet *skippedEntries;

// Buttons
- (IBAction)skipitButtonPressedWithSave:(UIBarButtonItem *)sender;
- (IBAction)logitButtonPressedWithSave:(UIBarButtonItem *)sender;

// Initializers
- (void) initialSetupOfFormWithWorkout:(Workout *)workout;
- (void) initializeLogbookEntry;
- (void) setExerciseLogToggleVale: (BOOL) logged;
- (void) setProgressBarProgress;

@end
