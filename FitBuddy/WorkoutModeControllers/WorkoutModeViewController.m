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
#import "GymBuddyAppDelegate.h"

@implementation WorkoutModeViewController {
}

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
                                                      inManagedObjectContext:[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext];
            [self.logbookEntries addObject:tempEntry]; 
            if (DEBUG) NSLog(@"Added a new logbook entry for Workout%@ Exercise %@, index %d", self.workout.workout_name, self.exercise.name, idx);
        }
        
        self.logbookEntry = tempEntry;
    }
}

#pragma mark -
#pragma mark View initializers

-(void) loadFormDataFromExerciseObject
{
    self.navigationItem.title = self.exercise.name;
    self.workoutLabel.text = self.exercise.name;
    [super loadFormDataFromExerciseObject];
}

-(void) initialSetupOfFormWithWorkout:(Workout *)workout
{
    // The first entry from the Workout segue
    // Need to collect the workout object, the exercise object for the form and initialize logboook entries
    // After this is completed we should drop to the viewWillAppear. 
    self.workout = workout;
    self.exercises = workout.exercises;
    self.exercise = [self.exercises objectAtIndex:0];
    self.logbookEntries = [[NSMutableOrderedSet alloc]init];
    self.skippedEntries = [[NSMutableOrderedSet alloc]init];
    [self createViewsPlusOne];
    
    NSLog(@"Entering initialSetupOfFormWithWorkout: Workout %@, Exercise %@", self.workout.workout_name, self.exercise.name);
}

-(void)setToolbarBack:(NSString*)bgFilename toolbar:(UIToolbar*)toolbar {   

}

-(void) viewWillAppear:(BOOL)animated
{
    // Initialize form
    [self loadFormDataFromExerciseObject];
    [self initializeLogbookEntry];
    [self setProgressBarProgress];
    //self.workoutLabel.text = self.workout.workout_name;

    // Visual Stuff
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCARDIOW]];
    }
    else
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kRESISTANCEW]];
    }
    
    self.pageControl.numberOfPages = self.exercises.count;
    self.pageControl.currentPage = [self.exercises indexOfObject:self.exercise];
    
    
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
    
    if (DEBUG) NSLog(@"View will appear");
}

#pragma mark -
#pragma mark save

-(void) saveLogbookEntry: (BOOL) completed {
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
    
    NSLog(@"workout=%@ logbook=%@", self.workout.managedObjectContext.description, self.logbookEntry.managedObjectContext.description);
    
    self.logbookEntry.workout = self.workout;
    NSMutableOrderedSet *tempSet = [self.workout mutableOrderedSetValueForKey:@"logbookEntries"];
    [tempSet addObject:self.logbookEntry];
    
    NSError *error;
    [self.workout.managedObjectContext save:&error];
    NSLog(@"Saving logbook entry");
    
    [self setExerciseFromForm];
}

#pragma mark -
#pragma mark UI Control

#pragma mark swiper
- (void)handleSwipeAction:(UISwipeGestureRecognizer *)sender {
    [self gotoNext];
}

- (void) gotoNext {
    // Save changes to exercise info before moving
    [self setExerciseFromForm];
    
    // Set the index for the next exercise view
    NSUInteger index = [self.exercises indexOfObject:self.exercise];
    NSUInteger nextIndex = index + 1;
    if (nextIndex >= self.exercises.count) nextIndex = 0;
    
    [[self navigationController] pushViewController: 
     [self getNextController:[NSNumber numberWithUnsignedInteger:nextIndex]] animated:YES];    
}

- (void)handleReverseSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    // Save changes to exercise info before moving
    [self setExerciseFromForm];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.navigationController.viewControllers.count == 1) {
        [self createViews];
    }
}

-(void)moveScreen: (void(^)())block {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark exercise log toggles
// Only chages the color of the buttons
- (void) setExerciseLogToggleVale: (BOOL) logged
{
    NSLog(@"Logging");
    if (logged == YES) {
        self.logitButton.tintColor = GYMBUDDY_GREEN;
    }
    else if (logged == NO)
    {
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
        [self.progressBar setProgressTintColor: GYMBUDDY_GREEN];
        butColor = GYMBUDDY_GREEN;
    }
    else if (self.skippedEntries.count == self.exercises.count)
    {
        [self.progressBar setProgressTintColor: GYMBUDDY_RED];
        skip = self.skippedEntries.count;
        butColor = GYMBUDDY_RED;
    }
    else if (self.skippedEntries.count > 0)
    {
        [self.progressBar setProgressTintColor: GYMBUDDY_YELLOW];
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

- (IBAction)logitButtonPressedWithSave:(UIButton *)sender
{
    [self.skippedEntries removeObject:self.logbookEntry];
    
    // Toggles will update during the save. Give immediate feedback if it's the first time
    [self setExerciseLogToggleVale:YES];
    [self saveLogbookEntry: YES];
    [self setProgressBarProgress];
    [self gotoNext];
}

- (IBAction)skipitButtonPressedWithSave:(UIButton *)sender
{
    if (self.skippedEntries == nil) self.skippedEntries = [[NSMutableOrderedSet alloc]init];
    [self.skippedEntries addObject:self.logbookEntry];
    
    [self setExerciseLogToggleVale:NO];
    [self saveLogbookEntry: NO];
    [self setProgressBarProgress];
    [self gotoNext];
}

- (void)saveFormBeforeNotes:(id)sender 
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
            [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext deleteObject:lbe];
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
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier: GO_HOME_SEGUE sender: self];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Starting segue to logbook");
    
    SEL setFinalProgressSelector = sel_registerName("setFinalProgress:");
    NSInvocation *setFinalProgress = [NSInvocation invocationWithMethodSignature:[[segue.destinationViewController class] instanceMethodSignatureForSelector:setFinalProgressSelector]];
    setFinalProgress.target = segue.destinationViewController;
    setFinalProgress.selector = setFinalProgressSelector;
    
    if ([segue.destinationViewController respondsToSelector:setFinalProgressSelector]) {
        
        NSNumber *progressValue = [NSNumber numberWithFloat: self.progressBar.progress];
        [setFinalProgress setArgument:&progressValue atIndex:2];
        [setFinalProgress invoke];
        
        [segue.destinationViewController performSelector:@selector(setLogbookEntries:) withObject:self.logbookEntries];
    }
    
    if ([segue.identifier isEqualToString: (GO_HOME_SEGUE)]) {
        [self homeButtonCleanup];
    }
    
    if ([segue.identifier isEqualToString: NOTES_SEGUE]) {
        [self setExerciseFromForm];
    }
}

BOOL (^isInputEven)(int) = ^(int input) 
{
    if (input % 2 == 0) 
        return YES;
    else 
        return NO;
};

-(void)createViewsPlusOne {
    NSMutableArray *views = [[NSMutableArray alloc]initWithCapacity:self.exercises.count];
    
    for (int i = 0; i < self.exercises.count;i++) {
        [views addObject:[self getNextController:[NSNumber numberWithInt:i]]];
    }
    [views addObject:[self getNextController:0]];
    [self.navigationController setViewControllers:views animated:NO];
}

-(void)createViews {
    NSMutableArray *views = [[NSMutableArray alloc]initWithCapacity:self.exercises.count];
    
    for (int i = 0; i < self.exercises.count;i++) {
        [views addObject:[self getNextController:[NSNumber numberWithInt:i]]];
    }
    [views addObject:[self getNextController:0]];
    [self.navigationController setViewControllers:views animated:NO];
}


-(WorkoutModeViewController *)getNextController:(NSNumber *)idx {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard-Autolayout" bundle:nil];
    WorkoutModeViewController *nextView = [sb instantiateViewControllerWithIdentifier:@"WorkoutModeViewController"];

    [nextView setWorkout: self.workout];
    [nextView setExercise: [self.exercises objectAtIndex:idx.unsignedIntegerValue]];
    [nextView setLogbookEntries:self.logbookEntries];
    [nextView setSkippedEntries:self.skippedEntries];
    
    return nextView;
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
