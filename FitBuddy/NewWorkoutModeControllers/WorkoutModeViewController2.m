//
//  WorkoutModeViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeViewController2.h"
#import "FitBuddyMacros.h"

#import "FitBuddy-Swift.h"

@implementation WorkoutModeViewController2

#pragma mark ui components
@synthesize exerciseLabel = _exerciseLabel;

#pragma mark coredata support
@synthesize logbookEntry = _logbookEntry;

#pragma mark -
#pragma mark View initializers
-(void) loadFormDataFromExercise
{
    self.navigationItem.title = self.exercise.name;
    self.exerciseLabel.text = self.exercise.name;
    [super loadFormDataFromExerciseObject];
}

-(void) initialSetupOfFormWithExercise:(Exercise *)exercise
                            andLogbook: (LogbookEntry *) logbookEntry
                            forWorkout: (Workout *) workout
{
    self.exercise = exercise;
    self.logbookEntry = logbookEntry;
    self.workout = workout;
    
}

- (LogbookEntry *)logbookEntry
{
    if (_logbookEntry == nil)
    {
        _logbookEntry = [self initializeLogbookEntry];
    }
    
    return _logbookEntry;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Initialize form
    [self loadFormDataFromExercise];
    if (DEBUG) NSLog(@"View will appear");

}

-(void) viewDidAppear:(BOOL)animated
{
    if (DEBUG) NSLog(@"View did appear");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkoutWillAppear" object:self];
    
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setExerciseFromForm];
}

#pragma mark - Logbook
-(void) saveLogbookEntry {
    
    self.logbookEntry.date = [[NSDate alloc] init];
    self.logbookEntry.workout_name = self.workout.workout_name;
    self.logbookEntry.exercise_name = self.exercise.name;
    self.logbookEntry.notes = self.exercise.notes;
    
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        self.logbookEntry.pace = ((CardioExercise *)self.exercise).pace;
        self.logbookEntry.distance = ((CardioExercise *)self.exercise).distance;
        self.logbookEntry.duration = ((CardioExercise *)self.exercise).duration;
    }
    else
    {
        self.logbookEntry.reps = ((ResistanceExercise *)self.exercise).reps;
        self.logbookEntry.sets = ((ResistanceExercise *)self.exercise).sets;
        self.logbookEntry.weight = ((ResistanceExercise *)self.exercise).weight;
    }
    
    self.logbookEntry.workout = self.workout;
    
    NSMutableOrderedSet *tempSet = [self.workout.logbookEntries mutableCopy];
    
    [tempSet addObject:self.logbookEntry];
    
    NSError *error;
    [[self.logbookEntry managedObjectContext] save:&error];
    
    if (DEBUG) NSLog(@"Saving logbook entry");
    
    if (error)
    {
        NSLog(@"Error during saveLogbookEntry: %@", error);
    }
    
}

-(LogbookEntry *)initializeLogbookEntry
{
    LogbookEntry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:LOGBOOK_TABLE
                                                inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
    
    if (DEBUG) NSLog(@"Added a new logbook entry for Exercise %@", self.exercise.name);
    
    return newEntry;
}

-(void) setExerciseFromForm
{
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"] == YES)
    {
        ((CardioExercise *)self.exercise).pace = self.slotOneValue.text;
        ((CardioExercise *)self.exercise).duration = self.slotTwoValue.text;
        ((CardioExercise *)self.exercise).distance = self.slotThreeValue.text;
    }
    else
    {
        ((ResistanceExercise *)self.exercise).weight = self.slotOneValue.text;
        ((ResistanceExercise *)self.exercise).reps = self.slotTwoValue.text;
        ((ResistanceExercise *)self.exercise).sets = self.slotThreeValue.text;
    }
}

@end
