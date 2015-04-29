//
//  WorkoutAddViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutAddViewController.h"
#import "SwitchCell.h"
#import "GymBuddyAppDelegate.h"

#import "FitBuddy-Swift.h"

@implementation WorkoutAddViewController
{
    UITableViewCell *editCell;
    NSMutableArray *workoutSequence;
    NSMutableArray *assignedExercises;
    NSMutableArray *unassignedExercises;
  
}

@synthesize workoutNameTextField;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize workoutSet = _workoutSet;


-(void) setupFetchedResultsController
{
    [self createWorkoutSequenceArray];
    [self createTableDataArray];
}

-(void) createTableDataArray
{
    NSManagedObjectContext *context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [frc performFetch:nil];
    
    NSArray *results = [frc fetchedObjects];
    NSPredicate *unassigned = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", assignedExercises];
    unassignedExercises = [[results filteredArrayUsingPredicate:unassigned] mutableCopy];
    
    [self.tableView reloadData];

}


-(void) createWorkoutSequenceArray
{
    NSManagedObjectContext *context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_SEQUENCE];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workout == %@", self.workout];
    [request setPredicate:predicate];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [frc performFetch:nil];
    
    workoutSequence = [[NSMutableArray alloc] initWithArray:[frc fetchedObjects]];
    
    assignedExercises = [[NSMutableArray alloc] init];
    
    for (WorkoutSequence *wo in workoutSequence)
    {
        if (![assignedExercises containsObject:wo.exercise])
        {
            [assignedExercises addObject:wo.exercise];
            [self.workoutSet addObject: wo.exercise];
        }
    }
    
    if ([assignedExercises count] == 0)
    {
        assignedExercises = [[self.workout.exercises array] mutableCopy];
    }

}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    editCell = [self.tableView dequeueReusableCellWithIdentifier:@"Workout Edit Cell"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    [self setupFetchedResultsController];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup and initialize
    
    // Visual stuff
    self.navigationItem.title = nil;
        
    // Initialize the view
    self.workoutSet = [self.workout mutableOrderedSetValueForKey:@"exercises"];
    
    if ([self.workout.workout_name isEqualToString:@""])
    {
        self.workoutNameTextField.borderStyle = UITextBorderStyleNone;
        self.workoutNameTextField.textColor = [UIColor whiteColor];
    }
    
    // Dismiss Keyboard
    [self.workoutNameTextField addTarget:self
                                  action:@selector(workoutNameTextFieldFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];

    // Listen for checkboxes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkboxClicked:) 
                                                 name:kCHECKBOXTOGGLED
                                               object:nil];
    
    [self.tableView setEditing:YES];
    
    [self.tableView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataChanged) name:kUBIQUITYCHANGED  object:[GymBuddyAppDelegate sharedAppDelegate]];

}

- (void) workoutNameTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void) newExerciseTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)addWorkout:(UITextField *)sender {
    self.workout.workout_name = sender.text;
    
    [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext save:nil];
    NSLog(@"Workout saved %@", sender.text);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (![self.workoutNameTextField.text isEqualToString:self.workout.workout_name])
    {
        [self textFieldDidEndEditing:self.workoutNameTextField];
    }
    
    // Set the name for empty workout objects
    if (self.workout.workout_name.length == 0)
    {
        self.workout.workout_name = @"New Workout";
        [[self.workout managedObjectContext] save:nil];
    }
    
    
    NSManagedObjectContext *context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_SEQUENCE];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workout == %@", self.workout];
    [request setPredicate:predicate];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [frc performFetch:nil];
    
    for (WorkoutSequence *ws in [frc fetchedObjects])
    {
        [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext deleteObject:ws];
    }
    
    // Rebuild the workout sequence
    for (Exercise *exercise in assignedExercises)
    {
        WorkoutSequence *newWos = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"WorkoutSequence"
                                        inManagedObjectContext:[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext];
        
        newWos.workout = self.workout;
        newWos.exercise = exercise;
        newWos.sequence = [NSNumber numberWithInteger:([assignedExercises indexOfObject:exercise])];
    }
    
    NSError *err;
    [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext save:&err];
    
    if (err)
    {
        NSLog(@"Error saving workout: %@", err);
    }
    
    if (DEBUG) NSLog(@"Workout %@ created", self.workout.workout_name);
    
    [super viewWillDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 100.0;
    }
    else
    {
        return 60.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prototype Components
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    //UICheckboxButton *checkbox = (UICheckboxButton *)[cell viewWithTag:100];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:102];
    UISwitch *checkbox = (UISwitch *)[cell viewWithTag:103];
    
    // Add the data to the cell
    Exercise *exercise = nil;
    
    if (indexPath.section == 0)
    {
        exercise = [assignedExercises objectAtIndex:indexPath.row];
        cell.showsReorderControl = YES;
        [self.workoutSet addObject:exercise];
    }
    else
    {
        exercise = [unassignedExercises objectAtIndex:indexPath.row];
        cell.showsReorderControl = NO;
        [self.workoutSet removeObject:exercise];
    }
    
    label.text = exercise.name;
    [checkbox setOn:[self.workoutSet containsObject:exercise]];
    
    NSEntityDescription *desc = exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        icon.image = [UIImage imageNamed:kCARDIO];
    }
    else
    {
        icon.image = [UIImage imageNamed:kRESISTANCE];
    }

    return cell;
}

-(IBAction) checkboxClicked:(NSNotification *) sender
{
    // Retrieve the Exercise object from the checkbox reference
    SwitchCell *cell = (SwitchCell *) sender.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
   
    Exercise *exercise = nil;
    
    if (indexPath.section == 0)
    {
        exercise = [assignedExercises objectAtIndex:indexPath.row];
    }
    else
    {
        exercise = [unassignedExercises objectAtIndex:indexPath.row];
    }
    
    if ([cell.checkbox isOn])
    {
        [self.workoutSet addObject:exercise];
        [unassignedExercises removeObject:exercise];
        
        if (![assignedExercises containsObject:exercise])
        {
            [assignedExercises addObject:exercise];
        }
    }
    else
    {
        [self.workoutSet removeObject:exercise];
        [assignedExercises removeObject:exercise];
        
        if (![unassignedExercises containsObject:exercise])
        {
            [unassignedExercises addObject:exercise];
        }
    }
    
    [self.tableView reloadData];
    
    NSLog(@"Exercise: %@ added to Workout: %@ Count: %lu", exercise.name, self.workout.workout_name, (unsigned long)self.workout.exercises.count);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section < 1)
    {
        self.workoutNameTextField = (UITextField *)[editCell viewWithTag:100];
        [self.workoutNameTextField setDelegate:self];
        self.workoutNameTextField.text = self.workout.workout_name;
        self.workoutNameTextField.keyboardType = UIKeyboardTypeAlphabet;
        [editCell setBackgroundColor:kCOLOR_LTGRAY];
        return editCell;
    }
    else
    {
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
        [labelView setBackgroundColor: kCOLOR_LTGRAY];
        [labelView setAutoresizesSubviews:TRUE];
        
        // Create label with section title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 60.0)];
        label.text = @"EXERCISES";
        label.font = [UIFont systemFontOfSize:14.0];
        [label setTextColor: kCOLOR_DKGRAY];
        
        [labelView addSubview:label];
        
        return labelView;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return assignedExercises.count;
    }
    else
    {
        return unassignedExercises.count;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self addWorkout:textField];
}

#pragma mark - reordering
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return YES;
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    Exercise *row = [assignedExercises objectAtIndex:sourceIndexPath.row];
    [assignedExercises removeObjectAtIndex:sourceIndexPath.row];
    [assignedExercises insertObject:row atIndex:destinationIndexPath.row];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Exercise Segue"])
    {
        [segue.destinationViewController performSelector:@selector(setExerciseArray:) withObject:assignedExercises];
        [segue.destinationViewController performSelector:@selector(setWorkoutSet:) withObject:self.self.workoutSet];
    }
    
}

-(void) handleDataChanged
{
    self.workoutSet = [self.workout mutableOrderedSetValueForKey:@"exercises"];

    [self setupFetchedResultsController];
}


- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
