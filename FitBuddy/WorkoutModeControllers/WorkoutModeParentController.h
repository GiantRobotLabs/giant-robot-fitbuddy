//
//  WorkoutModeParentController.h
//  GymBuddy
//
//  Created by John Neyer on 8/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "Exercise.h"

@interface WorkoutModeParentController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIProgressView *progressBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *finishButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *notesButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *skipitButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *logitButton;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UILabel *workoutLabel;

@property (nonatomic,strong) Workout *workout;
@property (nonatomic,strong) Exercise *exercise;

@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;

-(IBAction)changePage:(id)sender;

@end
