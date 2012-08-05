//
//  WorkoutModeViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeViewController.h"
#import "CoreDataHelper.h"
#import "CardioExercise.h"
#import "ResistanceExercise.h"

@implementation WorkoutModeViewController

#pragma mark ui components
@synthesize pageControl = _pageControl;
@synthesize skipitButton = _skipitButton;
@synthesize logitButton = _logitButton;
@synthesize progressBar = _progressBar;
@synthesize toolBar = _toolBar;
@synthesize homeButton = _homeButton;
@synthesize workoutLabel = _workoutLabel;

#pragma mark coredata support
@synthesize workout = _workout;
@synthesize exercises = _exercises;
@synthesize logbookEntry = _logbookEntry;
@synthesize skippedEntries = _skippedEntries;

#pragma mark local dictionary of logbookEntries
@synthesize logbookEntries = _logbookEntries;

#pragma mark -
#pragma mark initializers

-(void) setWorkout:(Workout *)workout
{
    _workout = workout;
    self.exercises = [workout.exercises mutableCopy];
}

-(void)initializeLogbookEntry
{    
    if (self.workout && self.exercise)
    {
        int idx = [self.exercises indexOfObject:self.exercise];
        
        // Try to get the logbook entry from the dictionary
        LogbookEntry *tempEntry = nil;
        if (self.logbookEntries.count > idx) tempEntry = [self.logbookEntries objectAtIndex:idx];
        
        if (tempEntry == nil)
        {
            tempEntry = [NSEntityDescription insertNewObjectForEntityForName:LOGBOOK_TABLE
                                                      inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
            [self.logbookEntries addObject:tempEntry]; 
            //if (DEBUG) NSLog(@"Added a new logbook entry for Workout%@ Exercise %@, index %d", self.workout.workout_name, self.exercise.name, idx);
        }
        
        self.logbookEntry = tempEntry;
    }
}

#pragma mark -
#pragma mark View initializers

-(void) loadFormDataFromExerciseObject
{
    self.navigationItem.title = self.exercise.name;
    [super loadFormDataFromExerciseObject];
}

-(void) initialSetupOfFormWithWorkout:(Workout *)workout
{
    // The first entry from the Workout segue
    // Need to collect the workout object, the exercise object for the form and initialize logboook entries
    // After this is completed we should drop to the viewWillAppear. 
    self.workout = workout;
    self.exercise = [self.exercises objectAtIndex:0];
    self.logbookEntries = [[NSMutableOrderedSet alloc]init];
    
    //if (DEBUG) NSLog(@"Entering initialSetupOfFormWithWorkout: Workout %@, Exercise %@", 
    //                 self.workout.workout_name, self.exercise.name);
}

-(void)setToolbarBack:(NSString*)bgFilename toolbar:(UIToolbar*)toolbar {   
    // Add Custom Toolbar
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgFilename]];
    iv.frame = CGRectMake(0, 0, toolbar.frame.size.width, toolbar.frame.size.height);
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // Add the tab bar controller's view to the window and display.
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 5)
        [toolbar insertSubview:iv atIndex:1]; // iOS5 atIndex:1
    else
        [toolbar insertSubview:iv atIndex:0]; // iOS4 atIndex:0
    toolbar.backgroundColor = [UIColor clearColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Initialize form
    [self loadFormDataFromExerciseObject];
    [self initializeLogbookEntry];
    [self setProgressBarProgress];
    self.workoutLabel.text = self.workout.workout_name;

    // Visual Stuff
    UIImage *backgroundImage;
    UIImage *titlebarImage;
    
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        backgroundImage = [UIImage imageNamed:GB_CHROME_CAR_BG];
        titlebarImage = [UIImage imageNamed:GB_CHROME_CAR_TB];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:GB_CHROME_WO_BG];
        titlebarImage = [UIImage imageNamed:GB_CHROME_WO_TB];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [[self.navigationController navigationBar] setBackgroundImage:titlebarImage forBarMetrics:UIBarMetricsDefault];
    self.slotOneValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.slotTwoValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.slotThreeValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.pageControl.numberOfPages = self.exercises.count;
    self.pageControl.currentPage = [self.exercises indexOfObject:self.exercise];
    
    [self setToolbarBack:GB_BG_CHROME_BOTTOM toolbar:self.toolBar];
    
    //Try to set the toggles if we're transitioning from ourself
    if (self.logbookEntry.completed != nil)
    {
        [self setExerciseLogToggleVale: [self.logbookEntry.completed boolValue]];
    }
    
    // Set the swiper
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];
     
    // Set the back swiper
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleReverseSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:recognizer];
    
    //if (DEBUG) NSLog(@"View will appear");
}

#pragma mark -
#pragma mark save

-(void) saveLogbookEntry: (BOOL) completed
{
    [self initializeLogbookEntry];
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
    
    self.logbookEntry.completed = [NSNumber numberWithBool: completed];
    
    //if (DEBUG) NSLog(@"workout=%@ logbook=%@", self.workout.managedObjectContext.description, self.logbookEntry.managedObjectContext.description);
    self.logbookEntry.workout = self.workout;
    NSMutableOrderedSet *tempSet = [self.workout mutableOrderedSetValueForKey:@"logbookEntries"];
    [tempSet addObject:self.logbookEntry];
    
    [self setExerciseFromForm];
}

#pragma mark -
#pragma mark UI Control

#pragma mark swiper
- (IBAction)handleSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    [self gotoNext];
}

- (void) gotoNext
{
    // Save changes to exercise info before moving
    [self setExerciseFromForm];
    
    int increment = 1;
    
    // Set the index for the next exercise view
    NSUInteger index = [self.exercises indexOfObject:self.exercise];
    if (index == self.exercises.count - 1) index = 0;
    else index = index + increment;
    
    // Perform the segue
    self.exercise = [self.workout.exercises objectAtIndex:index];
    [self performSegueWithIdentifier: WORKOUT_MODE_SEGUE sender: self];
}

- (IBAction)handleReverseSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    // Save changes to exercise info before moving
    [self setExerciseFromForm];
    
    int increment = -1;
    
    // Set the index for the next exercise view
    NSUInteger index = [self.exercises indexOfObject:self.exercise];
    if (index == 0) index = self.exercises.count - 1;
    else index = index + increment;
    
    // Perform the segue
    self.exercise = [self.workout.exercises objectAtIndex:index];
    //[self performSegueWithIdentifier: WORKOUT_REVERSE_SEGUE sender: self];
    
    UIViewController *lastView = [self presentingViewController];
    
    if ([lastView respondsToSelector:@selector(setWorkout:)]) {
        NSLog(@"setWorkout");
        [lastView performSelector:@selector(setWorkout:) withObject:self.workout];
    }
    if ([lastView respondsToSelector:@selector(setExercise:)]) {
        NSLog(@"setExercise");
        [lastView performSelector:@selector(setExercise:) withObject:self.exercise];
    }
    if ([lastView respondsToSelector:@selector(setLogbookEntries:)]) {
        NSLog(@"setLogEntries");
        [lastView performSelector:@selector(setLogbookEntries:) withObject: self.logbookEntries];
    }
    if ([lastView respondsToSelector:@selector(setSkippedEntries:)]) {
        NSLog(@"setSkipEntries");
        [lastView performSelector:@selector(setSkippedEntries:) withObject: self.skippedEntries];
    }
    if ([lastView respondsToSelector:@selector(setFinalProgress:)]) {
        NSLog(@"setFinalProgress");
        [lastView performSelector:@selector(setFinalProgress:) 
                                              withObject: [NSNumber numberWithFloat: self.progressBar.progress]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark exercise log toggles
// Only chages the color of the buttons
- (void) setExerciseLogToggleVale: (BOOL) logged
{
    if (logged == YES) {
        self.skipitButton.tintColor = [UIColor blackColor];
        self.logitButton.tintColor = GYMBUDDY_GREEN;
    }
    else if (logged == NO)
    {
        self.logitButton.tintColor = [UIColor blackColor];
        self.skipitButton.tintColor = GYMBUDDY_RED;   
    }
}

#pragma mark progress bar
- (void) setProgressBarProgress
{
    int skip = 0;
    UIColor *butColor;
    
    if (self.skippedEntries == nil || self.skippedEntries.count == 0)
    {
        self.progressBar.progressTintColor = GYMBUDDY_GREEN;
        butColor = GYMBUDDY_GREEN;
    }
    else if (self.skippedEntries.count == self.exercises.count)
    {
        self.progressBar.progressTintColor = GYMBUDDY_RED;
        skip = self.skippedEntries.count;
        butColor = GYMBUDDY_RED;
    }
    else if (self.skippedEntries.count > 0)
    {
        self.progressBar.progressTintColor = GYMBUDDY_YELLOW;
        skip = self.skippedEntries.count;
        butColor = GYMBUDDY_YELLOW;
    }
    
    NSIndexSet *count = [self.logbookEntries indexesOfObjectsPassingTest:
                        ^BOOL (LogbookEntry* obj, 
                               NSUInteger idx, 
                               BOOL *stop) 
    {
        if (obj.completed != nil) return YES;
        else return NO;
    }];
    
    float prog = count.count*1.0 / self.exercises.count*1.0;
    self.progressBar.progress = prog;
    
    
}

- (IBAction)logitButtonPressedWithSave:(UIBarButtonItem *)sender 
{
    if (self.skippedEntries == nil) self.skippedEntries = [[NSMutableOrderedSet alloc]init];
    [self.skippedEntries removeObject:self.logbookEntry];
    
    // Toggles will update during the save. Give immediate feedback if it's the first time
    [self setExerciseLogToggleVale:YES];
    [self saveLogbookEntry: YES];
    [self setProgressBarProgress];
    [self gotoNext];
}

- (IBAction)skipitButtonPressedWithSave:(UIBarButtonItem *)sender 
{
    if (self.skippedEntries == nil) self.skippedEntries = [[NSMutableOrderedSet alloc]init];
    [self.skippedEntries addObject:self.logbookEntry];
    
    [self setExerciseLogToggleVale:NO];
    [self saveLogbookEntry: NO];
    [self setProgressBarProgress];
    [self gotoNext];
}

- (IBAction)saveFormBeforeNotes:(id)sender 
{
    [self setExerciseFromForm];
}

- (void) homeButtonCleanup 
{
    // We're leaving. Clean up after yourself.
    
    NSIndexSet *count = [self.logbookEntries indexesOfObjectsPassingTest:
                         ^BOOL (LogbookEntry* obj, 
                                NSUInteger idx, 
                                BOOL *stop) 
                         {
                             if (obj.completed == nil) return YES;
                             else return NO;
                         }];

    if (count.count > 0)
    {
       // if (DEBUG) NSLog(@"Deleting %d unset logbookEntries", count.count);
        
        NSArray *array = [self.logbookEntries objectsAtIndexes:count];
        
        for (LogbookEntry *lbe in array)
        {
            [[CoreDataHelper getActiveManagedObjectContext] deleteObject:lbe];
        }
        
        [self.logbookEntries removeObjectsAtIndexes:count];
    }
}

#pragma mark -
#pragma mark Segue

- (IBAction)goHomeButtonPressed:(UIBarButtonItem *)sender 
{
    if (self.progressBar.progress < 1 || self.skippedEntries.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Finish Workout?"
                              message: @"Some exercies haven't been completed. Finish to exit and save to the log or Cancel to return to workout.\n\n(swipe to go to the next exercise)"
                              delegate: self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Finish", nil];
        [alert show];
    }
    else
    {
        [self performSegueWithIdentifier: GO_HOME_SEGUE sender: self];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // User clicked the finish button
    if (buttonIndex == 1)
    {
        [self performSegueWithIdentifier: GO_HOME_SEGUE sender: self];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the torch
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:self.workout];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:self.exercise];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setLogbookEntries:)]) {
        [segue.destinationViewController performSelector:@selector(setLogbookEntries:) withObject: self.logbookEntries];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setSkippedEntries:)]) {
        [segue.destinationViewController performSelector:@selector(setSkippedEntries:) withObject: self.skippedEntries];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setFinalProgress:)]) {
        [segue.destinationViewController performSelector:@selector(setFinalProgress:) 
                                              withObject: [NSNumber numberWithFloat: self.progressBar.progress]];
    }
    
    if ([segue.identifier isEqualToString: (GO_HOME_SEGUE)])
    {
        [self homeButtonCleanup];
    }
    
    if ([segue.identifier isEqualToString: NOTES_SEGUE])
    {
        [self setExerciseFromForm];
    }
}

- (void)viewDidUnload {
    [self setSkipitButton:nil];
    [self setLogitButton:nil];
    [self setProgressBar:nil];
    [self setToolBar:nil];
    [self setHomeButton:nil];
    [self setWorkoutLabel:nil];
    [super viewDidUnload];
}
@end
