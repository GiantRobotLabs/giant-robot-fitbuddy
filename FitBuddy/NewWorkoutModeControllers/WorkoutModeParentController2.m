//
//  WorkoutModeParentController.m
//  GymBuddy
//
//  Created by John Neyer on 8/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeParentController2.h"
#import "WorkoutModeViewController2.h"
#import "FitBuddyMacros.h"
#import "GymBuddyAppDelegate.h"

@interface WorkoutModeParentController2 ()
{
    WorkoutModeViewController2 *currentViewController;
}

@property (assign) BOOL rotating;
@property (assign) NSUInteger page;
@property (assign) BOOL pageControlUsed;

@end

@implementation WorkoutModeParentController2

@synthesize workout = _workout;
@synthesize exerciseArray = _exerciseArray;

@synthesize pageControl = _pageControl;
@synthesize progressBar = _progressBar;
@synthesize finishButton = _finishButton;
@synthesize notesButton = _notesButton;
@synthesize skipitButton = _skipitButton;
@synthesize logitButton = _logitButton;

@synthesize skippedEntries = _skippedEntries;
@synthesize logbookEntries = _logbookEntries;

- (void) loadExerciseArray
{
    NSManagedObjectContext *context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_SEQUENCE];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workout == %@", self.workout];
    [request setPredicate:predicate];
        
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]];
        
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
    [frc performFetch:nil];
        
    NSArray *workoutSequence = [[NSMutableArray alloc] initWithArray:[frc fetchedObjects]];
        
    self.exerciseArray = [[NSMutableArray alloc] init];
        
    for (WorkoutSequence *wo in workoutSequence)
    {
        [self.exerciseArray addObject:wo.exercise];
    }
    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self loadExerciseArray];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    WorkoutModeViewController2 *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.pageControl setNumberOfPages:self.exerciseArray.count];
    [self.pageControl setCurrentPage:0];
    [self.progressBar setProgress:0];
    
    [self.view bringSubviewToFront:self.workoutControlPanel];
    
    self.logitButton.backgroundColor = kCOLOR_GRAY;
    self.skipitButton.backgroundColor = kCOLOR_GRAY;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterface:) name:@"WorkoutWillAppear" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //currentViewController has to be set on initialization
    currentViewController = [self viewControllerAtIndex:0];
    [self setExerciseTypeIcon];

}

-(void) setExerciseTypeIcon
{
    // Visual Stuff
    NSEntityDescription *desc = currentViewController.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCARDIOWHITE]];
    }
    else
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kRESISTANCEWHITE]];
    }
}


- (NSMutableOrderedSet *)skippedEntries
{
    if (_skippedEntries == nil)
    {
        _skippedEntries = [[NSMutableOrderedSet alloc]init];
    }
    
    return _skippedEntries;
}

- (NSMutableDictionary *)logbookEntries
{
    if (_logbookEntries == nil)
    {
        _logbookEntries = [[NSMutableDictionary alloc] init];
    }
    
    return _logbookEntries;
}

-(void) initialSetupOfFormWithWorkout:(Workout *)workout
{
    self.workout = workout;
    _skippedEntries = [[NSMutableOrderedSet alloc]init];
}

#pragma mark - UIPageViewDelegate
- (WorkoutModeViewController2 *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.exerciseArray count] == 0) || (index >= [self.exerciseArray count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WorkoutModeViewController2 *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkoutContentViewController"];
   
    [pageContentViewController initialSetupOfFormWithExercise: self.exerciseArray[index] andLogbook:[self.logbookEntries objectForKey:[NSNumber numberWithInteger:index]] forWorkout:self.workout];

    [pageContentViewController setPageIndex:index];
    
    return pageContentViewController;
}

-(void) updateInterface: (NSNotification *) sender
{
    
    if (DEBUG) NSLog(@"Updating UI for parent controller");
    currentViewController = (WorkoutModeViewController2 *)sender.object;
    ;
    self.logitButton.backgroundColor = kCOLOR_GRAY;
    self.skipitButton.backgroundColor = kCOLOR_GRAY;
    
    [self.pageControl setCurrentPage: currentViewController.pageIndex];
    
    LogbookEntry *logbookEntry = [self.logbookEntries objectForKey:[NSNumber numberWithInteger: currentViewController.pageIndex]];
    
    if  (logbookEntry)
    {
        [self setExerciseLogToggleValue: [logbookEntry.completed boolValue]];
    }
    
    [self setExerciseTypeIcon];
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WorkoutModeViewController2 *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WorkoutModeViewController2*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.exerciseArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.exerciseArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Exercise Controller
// Only chages the color of the buttons

- (void) setExerciseLogToggleValue: (BOOL) logged
{
    // Reset the colors
    self.logitButton.backgroundColor = kCOLOR_GRAY;
    self.skipitButton.backgroundColor = kCOLOR_GRAY;
    
    NSLog(@"Logging");
    if (logged == YES) {
        self.logitButton.tintColor = GYMBUDDY_GREEN;
        self.logitButton.backgroundColor = GYMBUDDY_GREEN;
    }
    else if (logged == NO)
    {
        self.skipitButton.tintColor = GYMBUDDY_YELLOW;
        self.skipitButton.backgroundColor = GYMBUDDY_YELLOW;
    }
}

#pragma mark progress bar
- (void) setProgressBarProgress
{
    
    UIColor *butColor;
    
    if (self.skippedEntries == nil || self.skippedEntries.count == 0)
    {
        [self.progressBar setProgressTintColor: GYMBUDDY_GREEN];
        butColor = GYMBUDDY_GREEN;
    }
    else if (self.skippedEntries.count == self.exerciseArray.count)
    {
        [self.progressBar setProgressTintColor: GYMBUDDY_RED];
 
        butColor = GYMBUDDY_RED;
    }
    else if (self.skippedEntries.count > 0)
    {
        [self.progressBar setProgressTintColor: GYMBUDDY_YELLOW];
 
        butColor = GYMBUDDY_YELLOW;
    }
    
    NSIndexSet *count = [[self.logbookEntries allValues] indexesOfObjectsPassingTest:
                         ^BOOL (LogbookEntry* obj,
                                NSUInteger idx,
                                BOOL *stop)
                         {
                             if (obj.completed != nil) return YES;
                             else return NO;
                         }];
    
    float prog = count.count*1.0 / self.exerciseArray.count*1.0;
    self.progressBar.progress = prog;
    
    
}

- (IBAction)logitButtonPressed:(UIButton *)sender
{
    [currentViewController.logbookEntry setCompleted:[NSNumber numberWithBool:YES]];
    [currentViewController saveLogbookEntry];
    [self.skippedEntries removeObject:currentViewController.logbookEntry];
    [self.logbookEntries setObject:currentViewController.logbookEntry
                            forKey:[NSNumber numberWithInteger:currentViewController.pageIndex]];
    
    // Toggles will update during the save. Give immediate feedback if it's the first time
    [self setExerciseLogToggleValue:YES];
    [self setProgressBarProgress];
    [currentViewController saveLogbookEntry];
    
}

- (IBAction)skipitButtonPressed:(UIButton *)sender
{
    [currentViewController.logbookEntry setCompleted:[NSNumber numberWithBool:NO]];
    [self.skippedEntries addObject:currentViewController.logbookEntry];
    [self.logbookEntries setObject:currentViewController.logbookEntry
                            forKey:[NSNumber numberWithInteger:currentViewController.pageIndex]];
    
    [self setExerciseLogToggleValue:NO];
    [self setProgressBarProgress];
    [currentViewController saveLogbookEntry];
}

#pragma mark -
#pragma mark Segue
- (IBAction)goHomeButtonPressed:(UIBarButtonItem *)sender
{
    if (self.progressBar.progress < 1 || self.skippedEntries.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Complete Workout?"
                              message: @"Some exercies haven't been completed. Tap Finish to exit and save to the log or Cancel to return to workout.\n\n(swipe to go to the next exercise)"
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

- (void) homeButtonCleanup
{
    // We're leaving. Clean up after yourself.
    [currentViewController saveLogbookEntry];
    
    NSArray *logValues = [self.logbookEntries allValues];
    
    NSIndexSet *count = [logValues indexesOfObjectsPassingTest:
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
        
        NSArray *array = [logValues objectsAtIndexes:count];
        
        for (LogbookEntry *lbe in array)
        {
            [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext deleteObject:lbe];
        }
        
        NSSet *keys = [self.logbookEntries keysOfEntriesPassingTest:
                 ^BOOL(id key, id obj, BOOL *stop) {
                     if ([array containsObject:obj])
                     {
                         return YES;
                     }
                     return NO;
                 }];
        
        [self.logbookEntries removeObjectsForKeys: keys.allObjects];
    }

}

-(void) nextPage
{

    
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Starting segue to final results");
    
    [currentViewController setExerciseFromForm];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setFinalProgress:)]) {
        
        self.workout.last_workout = ((LogbookEntry *)[[self.logbookEntries allValues] lastObject]).date;

        NSNumber *progressValue = [NSNumber numberWithFloat: self.progressBar.progress];
        [segue.destinationViewController performSelector:@selector(setFinalProgress:) withObject:progressValue];
        [segue.destinationViewController performSelector:@selector(setLogbookEntries:) withObject:self.logbookEntries];
    }
    
    if ([segue.identifier isEqualToString: (GO_HOME_SEGUE)]) {
        [self homeButtonCleanup];
    }
    
    if ([segue.identifier isEqualToString: NOTES_SEGUE]) {
        [segue.destinationViewController performSelector: @selector(setExercise:) withObject:currentViewController.exercise];
    }
}


@end
