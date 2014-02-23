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

@implementation WorkoutAddViewController
{
    UITableViewCell *editCell;
}

@synthesize workoutNameTextField;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize workoutSet = _workoutSet;


-(void) setupFetchedResultsController
{
    NSManagedObjectContext *context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
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
    
    //if (DEBUG) NSLog(@"View will appear");
}

- (void) workoutNameTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void) newExerciseTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)addWorkout:(UITextField *)sender {
    self.workout.workout_name = sender.text;
    
    [[GymBuddyAppDelegate sharedAppDelegate] saveContext];
    NSLog(@"Workout saved %@", sender.text);
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (![self.workoutNameTextField.text isEqualToString:self.workout.workout_name])
    {
        [self textFieldDidEndEditing:self.workoutNameTextField];
    }
    
    // Set the name for empty workout objects
    if (!self.workout.workout_name)
    {
        self.workout.workout_name = @"New Workout";
    }
    
    [[GymBuddyAppDelegate sharedAppDelegate]saveContext];
    NSLog(@"Workout %@ created", self.workout.workout_name);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.0;
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
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    [checkbox setOn:[self.workoutSet containsObject:exercise]];
    //checkbox.checked = [self.workoutSet containsObject:exercise];
    
    NSEntityDescription *desc = exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        icon.image = [UIImage imageNamed:kCARDIO];
    }
    else
    {
        icon.image = [UIImage imageNamed:kRESISTANCE];
    }

    
    cell.showsReorderControl = YES;
    return cell;
}

-(IBAction) checkboxClicked:(NSNotification *) sender
{
    // Retrieve the Exercise object from the checkbox reference
    SwitchCell *cell = (SwitchCell *) sender.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"Exercise: %@ added to Workout: %@", exercise.name,  self.workout.workout_name);
    
    if ([cell.checkbox isOn])
    {
        [self.workoutSet addObject:exercise];
    }
    else
    {
        [self.workout mutableOrderedSetValueForKey:@"exercises"];
        [self.workoutSet removeObject:exercise];
    }
    
    NSLog(@"Exercise: %@ added to Workout: %@ Count: %d", exercise.name, self.workout.workout_name, self.workout.exercises.count);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.workoutNameTextField = (UITextField *)[editCell viewWithTag:100];
    [self.workoutNameTextField setDelegate:self];
    self.workoutNameTextField.text = self.workout.workout_name;
    self.workoutNameTextField.keyboardType = UIKeyboardTypeAlphabet;
    [editCell setBackgroundColor:kCOLOR_LTGRAY];
    return editCell;
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
    return NO;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}


- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
