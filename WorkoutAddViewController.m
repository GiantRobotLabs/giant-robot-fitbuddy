//
//  WorkoutAddViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutAddViewController.h"
#import "CoreDataHelper.h"
#import "UICheckboxButton.h"
#import "GymBuddyMacros.h"

@implementation WorkoutAddViewController

@synthesize workoutNameTextField;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize workoutSet = _workoutSet;

@synthesize document = _document;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

-(void)setDocument:(UIManagedDocument *) document
{
    if (_document != document)
    {
        _document = document;
        [self setupFetchedResultsController];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    // Setup and initialize
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Initialize the view
    self.workoutSet = [self.workout mutableOrderedSetValueForKey:@"exercises"];
    
    if ([self.workout.workout_name isEqualToString:@""])
    {
        self.workoutNameTextField.borderStyle = UITextBorderStyleNone;
        self.workoutNameTextField.textColor = [UIColor whiteColor];
    }
    
    self.workoutNameTextField.text = self.workout.workout_name;
    
    // Setup the database
    if (!self.document)
    {
        [CoreDataHelper openDatabase:DATABASE usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
        }];
    }  
    
    // Dismiss Keyboard
    [self.workoutNameTextField addTarget:self
                                  action:@selector(workoutNameTextFieldFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];

    // Listen for checkboxes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkboxClicked:) 
                                                 name:@"CheckboxToggled"
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
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Set the name for empty workout objects
    if (!self.workout.workout_name)
    {
        self.workout.workout_name = @"Empty Workout";
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prototype Components
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UICheckboxButton *checkbox = (UICheckboxButton *)[cell viewWithTag:100];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:102];
    
    // Visual stuff
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    cell.backgroundView = bgView;
    
    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    checkbox.checked = [self.workoutSet containsObject:exercise];
    
    NSEntityDescription *desc = exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        icon.image = [UIImage imageNamed:GB_CARDIO_IMAGE]; 
    }
    else
    {
        icon.image = [UIImage imageNamed:GB_RESISTANCE_IMAGE];
    }

    return cell;
}

-(IBAction) checkboxClicked:(NSNotification *) sender
{
    // Retrieve the Exercise object from the checkbox reference
    UIView *contentView = [(UICheckboxButton *)sender.object superview];
    UITableViewCell *cell = (UITableViewCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //if (DEBUG) NSLog(@"Exercise: %@ added to Workout: %@", exercise.name,  self.workout.workout_name);
    
    if (((UICheckboxButton *)sender.object).checked)
    {
        [self.workoutSet addObject:exercise];
    }
    else
    {
        [self.workout mutableOrderedSetValueForKey:@"exercises"];
        [self.workoutSet removeObject:exercise];
    }
    
    //if (DEBUG) NSLog(@"Exercise: %@ added to Workout: %@ Count: %d", exercise.name,  
    //      self.workout.workout_name, self.workout.exercises.count);
    
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
