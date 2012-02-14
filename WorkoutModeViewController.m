//
//  WorkoutModeViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeViewController.h"
#import "LogbookEntry.h"
#import "CoreDataHelper.h"

@implementation WorkoutModeViewController

@synthesize weightLabel = _weightLabel;
@synthesize repsLabel = _repsLabel;
@synthesize setsLabel = _setsLabel;
@synthesize weightIncrementLabel = _weightIncrementLabel;
@synthesize nameValue = _nameValue;
@synthesize pageControl = _pageControl;
@synthesize skipitButton = _skipitButton;
@synthesize logitButton = _logitButton;
@synthesize progressBar = _progressBar;
@synthesize toolBar = _toolBar;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize exercises = _exercises;
@synthesize logbookEntry = _logbookEntry;
@synthesize logbookEntries = _logbookEntries;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void) setWorkout:(Workout *)workout
{
    _workout = workout;
    self.exercises = [workout.exercises mutableCopy];
}

-(void) initialSetupWithWorkout:(Workout *)workout
{
    [CoreDataHelper callSave:[CoreDataHelper getActiveManagedObjectContext]];
    self.workout = workout;
    self.exercise = [self.exercises objectAtIndex:0];
    
    self.logbookEntries = [[NSMutableOrderedSet alloc]init];
    //[self initializeLogbookEntry];
    
    if (DEBUG) NSLog(@"WorkoutModeController: Initial setup, Exercise = %@", self.exercise.name);
}

-(void) setLogbookEntry:(LogbookEntry *)logbookEntry
{
    _logbookEntry = logbookEntry;
    
    //Set the toggles
    if (self.logbookEntry.completed != nil)
    {
        if ([self.logbookEntry.completed boolValue]) 
            [self logitButtonPressed: self.logitButton];
        else
            [self skipitButtonPressed: self.skipitButton];
    }
}

-(void)initializeLogbookEntry
{    
    if (self.workout && self.exercise)
    {
        int idx = [self.exercises indexOfObject:self.exercise];
        
        LogbookEntry *tempEntry = nil;
        if(self.logbookEntries.count >= idx + 1) tempEntry = [self.logbookEntries objectAtIndex:idx];
        
        if (tempEntry == nil)
        {
            tempEntry = [NSEntityDescription insertNewObjectForEntityForName:LOGBOOK_TABLE
                                                      inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
        
            [self.logbookEntries addObject:tempEntry]; 
            if (DEBUG) NSLog(@"Added a new logbook entry for Workout%@ Exercise %@, index %d", self.workout.workout_name, self.exercise.name, idx);
        }
        else
        {
            if (DEBUG) NSLog(@"Using existing logbook entry for Workout%@ Exercise %@", self.workout.workout_name, self.exercise.name);
        }
        
        self.logbookEntry = tempEntry;
    }
}

-(void) saveExerciseState
{
    self.exercise.weight = self.weightLabel.text;
    self.exercise.reps = self.repsLabel.text;
    self.exercise.sets = self.setsLabel.text;   
}

-(void) saveLogbookEntry
{
    if (self.logbookEntries == nil) [self initializeLogbookEntry];
    
    self.logbookEntry.date = [[NSDate alloc] init];
    self.logbookEntry.workout_name = self.workout.workout_name;
    self.logbookEntry.exercise_name = self.exercise.name;
    self.logbookEntry.notes = self.exercise.notes;
    self.logbookEntry.reps = self.exercise.reps;
    self.logbookEntry.sets = self.exercise.sets;
    self.logbookEntry.weight = self.exercise.weight;
    self.logbookEntry.workout = self.workout;
    
    NSMutableOrderedSet *tempSet = [self.workout mutableOrderedSetValueForKey:@"logbookEntries"];
    [tempSet addObjectsFromArray:[self.logbookEntries array]];
    
    [self saveExerciseState];
    //[CoreDataHelper callSave:self.workout.managedObjectContext];
}

- (IBAction)handleSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    // Save changes to exercise info before moving
    [self saveExerciseState];
    
    int increment = 1;
    
    // Set the index for the next exercise view
    NSUInteger index = [self.exercises indexOfObject:self.exercise];
    if (index == self.exercises.count - 1) index = 0;
    else index = index + increment;

    // Perform the segue
    self.exercise = nil;
    self.exercise = [self.workout.exercises objectAtIndex:index];
    [self performSegueWithIdentifier: WORKOUT_MODE_SEGUE sender: self];
}

-(void) loadDataFromExerciseObject
{
    self.navigationItem.title = self.exercise.name;
    self.nameValue.text = self.exercise.name;
    self.setsLabel.text =self.exercise.sets;
    self.repsLabel.text = self.exercise.reps;
    self.weightLabel.text = self.exercise.weight;
}

-(void) viewWillAppear:(BOOL)animated
{
    // Initialize
    [self loadDataFromExerciseObject];
    if (self.logbookEntries != nil) [self initializeLogbookEntry];

    
    // Visual Stuff
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background-ui.png"]];
    self.weightLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.setsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.repsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.pageControl.numberOfPages = self.exercises.count;
    self.pageControl.currentPage = [self.exercises indexOfObject:self.exercise];
    
    // Set the swiper
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];
    
    if (DEBUG) NSLog(@"View will appear");
}

- (IBAction)weightIncrement:(UIButton *)sender {
    double increment = [self.weightIncrementLabel.text doubleValue];
    double weight = [self.weightLabel.text doubleValue];
    
    if ([@"+" isEqualToString:sender.currentTitle]) {
        weight += increment;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (weight >= increment) weight -= increment;
    }
    self.weightLabel.text = [NSString stringWithFormat:@"%g", weight];
}

- (IBAction)repsIncrement:(UIButton *)sender {
    double reps = [self.repsLabel.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        reps += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (reps >= 1) reps -= 1;
    }
    self.repsLabel.text = [NSString stringWithFormat:@"%g", reps];
}

- (IBAction)setsIncrement:(UIButton *)sender {
    double sets = [self.setsLabel.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        sets += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (sets >= 1) sets -= 1;
    }
    self.setsLabel.text = [NSString stringWithFormat:@"%g", sets];
}

- (IBAction)undoAllDataChangesSinceLastSave 
{
    [self loadDataFromExerciseObject];
}

- (IBAction)logitButtonPressed:(UIBarButtonItem *)sender 
{
    self.skipitButton.tintColor = [UIColor blackColor];
    self.logitButton.tintColor = GYMBUDDY_GREEN;

    [self saveLogbookEntry];
    self.logbookEntry.completed = [NSNumber numberWithBool:YES];
}

- (IBAction)skipitButtonPressed:(UIBarButtonItem *)sender 
{
    
    self.logitButton.tintColor = [UIColor blackColor];
    self.skipitButton.tintColor = GYMBUDDY_RED;

    [self saveLogbookEntry];
    self.logbookEntry.completed = [NSNumber numberWithBool:NO];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the torch
    if ([segue.destinationViewController respondsToSelector:@selector(setLogbookEntries:)]) {
        [segue.destinationViewController performSelector:@selector(setLogbookEntries:) withObject: self.logbookEntries];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:self.workout];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setExercises:)]) {
        [segue.destinationViewController performSelector:@selector(setExercises:) withObject:self.exercises];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:self.exercise];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    // Don't keep an empty logbook
    if (self.logbookEntry.date == nil)
    {
        [[CoreDataHelper getActiveManagedObjectContext] deleteObject:self.logbookEntry];
    }

}

- (void)viewDidUnload {
    [self setSkipitButton:nil];
    [self setLogitButton:nil];
    [self setProgressBar:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}
@end
