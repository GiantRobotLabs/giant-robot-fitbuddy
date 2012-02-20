//
//  WorkoutSummaryViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutSummaryViewController.h"
#import "GymBuddyMacros.h"
#import "LogbookEntry.h"

@implementation WorkoutSummaryViewController
@synthesize navigationBar;

@synthesize finalProgress = _finalProgress;
@synthesize logbookEntries = _logbookEntries;
@synthesize skippedEntries = _skippedEntries;
@synthesize completedValue = _completedValue;
@synthesize numExercisesValue = _numExercisesValue;
@synthesize totalResistanceValue = _totalResistanceValue;
@synthesize totalDistanceValue = _totalDistanceValue;

-(void) setForm
{
    self.completedValue.text = [NSString stringWithFormat:@"%1.0f%%", ([self.finalProgress floatValue] * 100)];
    self.numExercisesValue.text = [NSString stringWithFormat:@"%d", (self.logbookEntries.count - self.skippedEntries.count)];
    
    LogbookEntry *entry;
    float distance = 0.0;
    float resistance = 0.0;
    
    // Total Resistance = Sum of (Weight * Sets * Reps) for each complete logbook
    // Total Distance = Sum of (Pace * Time || Distance) for each complete logbook
    for (entry in self.logbookEntries)
    {
        if (entry.completed == [NSNumber numberWithInt:1])
        {
            if (entry.weight != nil)
            {
                resistance += [entry.weight floatValue] * [entry.reps floatValue] * [entry.sets floatValue];
            }
            if (entry.distance != nil && [entry.distance floatValue] > 0)
            {
                distance += [entry.distance floatValue];
            }
            else if (entry.pace != nil)
            {
                distance += [entry.pace floatValue] * [entry.duration floatValue];
            }
        }
    }
    
    self.totalDistanceValue.text = [NSString stringWithFormat:@"%1.1f", distance];
    self.totalResistanceValue.text = [NSString stringWithFormat:@"%1.0f", resistance];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Visual stuff
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    [self setForm];
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setCompletedValue:nil];
    [self setNumExercisesValue:nil];
    [self setTotalResistanceValue:nil];
    [self setTotalDistanceValue:nil];
    [super viewDidUnload];
}
@end
