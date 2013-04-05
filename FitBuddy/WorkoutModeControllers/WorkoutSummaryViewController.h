//
//  WorkoutSummaryViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogbookEntry.h"

@interface WorkoutSummaryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, strong) NSNumber *finalProgress;
@property (nonatomic, strong) NSOrderedSet *logbookEntries;
@property (nonatomic, strong) NSOrderedSet *skippedEntries;

@property (weak, nonatomic) IBOutlet UILabel *completedValue;
@property (weak, nonatomic) IBOutlet UILabel *numExercisesValue;
@property (weak, nonatomic) IBOutlet UILabel *totalResistanceValue;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceValue;
@property (weak, nonatomic) IBOutlet UIImageView *strengthLight;
@property (weak, nonatomic) IBOutlet UIImageView *cardioLight;

-(float) calculateWorkoutScore: (LogbookEntry *) entry;
-(float) calculateCardioScore: (LogbookEntry *) entry;

@end
