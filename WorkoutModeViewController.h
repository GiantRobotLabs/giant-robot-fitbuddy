//
//  WorkoutModeViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymBuddyViewController.h"

#import "GymBuddyMacros.h"

@interface WorkoutModeViewController : UIViewController

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightIncrementLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameValue;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

// Database
@property (nonatomic, weak) Workout *workout;
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, weak) NSOrderedSet *exercises;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
