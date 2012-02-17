//
//  WorkoutModeViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymBuddyViewController.h"
#import "LogbookEntry.h"

#import "GymBuddyMacros.h"

@interface WorkoutModeViewController : UIViewController

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightIncrementLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipitButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logitButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;

// Database
@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) NSOrderedSet *exercises;
@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (nonatomic, strong) NSMutableOrderedSet *logbookEntries;
@property (nonatomic, strong) NSMutableOrderedSet *skippedEntries;

- (void) initialSetupOfFormWithWorkout:(Workout *)workout;
- (IBAction)skipitButtonPressedWithSave:(UIBarButtonItem *)sender;
- (IBAction)logitButtonPressedWithSave:(UIBarButtonItem *)sender;
- (void) initializeLogbookEntry;
- (void) setExerciseLogToggleVale: (BOOL) logged;
- (IBAction)undoAllDataChangesSinceLastSave;
- (void) setProgressBarProgress;

@end
