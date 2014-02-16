//
//  WorkoutModeViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeViewController2.h"
#import "CoreDataHelper.h"
#import "CardioExercise.h"
#import "ResistanceExercise.h"
#import "GymBuddyAppDelegate.h"

@implementation WorkoutModeViewController2

#pragma mark ui components
@synthesize exerciseLabel = _exerciseLabel;

#pragma mark coredata support
@synthesize logbookEntry = _logbookEntry;

#pragma mark -
#pragma mark View initializers
-(void) loadFormDataFromExerciseObject
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
    [self loadFormDataFromExerciseObject];
    if (DEBUG) NSLog(@"View will appear");
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (DEBUG) NSLog(@"View did appear");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkoutWillAppear" object:self];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self saveLogbookEntry];
    [super viewWillDisappear:animated];
}


#pragma mark - Logbook
-(void) saveLogbookEntry {
    
    [self setExerciseFromForm];
    
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
    NSMutableOrderedSet *tempSet = [self.workout mutableOrderedSetValueForKey:@"logbookEntries"];
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
                                                inManagedObjectContext:[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext];
    if (DEBUG) NSLog(@"Added a new logbook entry for Exercise %@", self.exercise.name);
    
    return newEntry;
}

@end
