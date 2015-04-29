//
//  WorkoutModeParentController.h
//  GymBuddy
//
//  Created by John Neyer on 8/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WorkoutModeViewController2.h"

@interface WorkoutModeParentController2 : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIProgressView *progressBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *finishButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *notesButton;
@property (nonatomic, weak) IBOutlet UIButton *skipitButton;
@property (nonatomic, weak) IBOutlet UIButton *logitButton;
@property (weak, nonatomic) IBOutlet UIView *workoutControlPanel;

@property (nonatomic, strong) NSMutableArray *exerciseArray;
@property (nonatomic,strong) Workout *workout;

@property (nonatomic, strong) NSMutableDictionary *logbookEntries;
@property (nonatomic, strong) NSMutableOrderedSet *skippedEntries;

// Buttons
- (IBAction) skipitButtonPressed:(UIButton *)sender;
- (IBAction) logitButtonPressed:(UIButton *)sender;

@end
