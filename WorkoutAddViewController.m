//
//  WorkoutAddViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutAddViewController.h"
#import "CoreDataHelper.h"

@implementation WorkoutAddViewController
@synthesize workoutNameTextField;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize workoutSet = _workoutSet;

@synthesize document = _document;


-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.workout.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
    
    NSLog(@"setupFRC: %d", [self.fetchedResultsController fetchedObjects].count);
}

-(void)setDocument:(UIManagedDocument *) document
{
    if (_document != document)
    {
        _document = document;
        [self setupFetchedResultsController];
    }
    NSLog(@"really standing in it");
}

-(void) viewWillAppear:(BOOL)animated
{
    // Setup and initialize
    
    [self.workoutNameTextField addTarget:self
                       action:@selector(workoutNameTextFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Initialize the view
    self.workoutSet = [self.workout mutableOrderedSetValueForKey:@"exercises"];
    self.workoutNameTextField.text = self.workout.workout_name;
    
    // Setup the database
    NSLog(@"you are here");
    if (!self.document)
    {
        NSLog(@"you're standing in it");
        [CoreDataHelper openDatabase:@"GymBuddy" usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
            NSLog(@"in the thick of it");
        }];
        NSLog(@"passed it");
    }  
    
    [self setupFetchedResultsController];

    // Listen for checkboxes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkboxClicked:) 
                                                 name:@"CheckboxToggled"
                                               object:nil];
    

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
    
    if (!self.workoutNameTextField.hasText) 
    {
        self.workout.workout_name = @"Empty Workout";
        NSLog(@"set workout name %@", self.workout.workout_name);
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Prototype Components
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UICheckboxButton *checkbox = (UICheckboxButton *)[cell viewWithTag:100];
    
    // Visual stuff
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    checkbox.checked = [self.workoutSet containsObject:exercise];
    
    return cell;
}

-(IBAction) checkboxClicked:(NSNotification *) sender
{
    // Retrieve the Exercise object from the checkbox reference
    UIView *contentView = [(UICheckboxButton *)sender.object superview];
    UITableViewCell *cell = (UITableViewCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"Exercise: %@ added to Workout: %@", exercise.name,  self.workout.workout_name);
    

    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    //request.predicate = [NSPredicate predicateWithFormat:@"name == %@", exercise.name];
    
    //NSError *error = nil;
    //NSArray *result = [self.workout.managedObjectContext executeFetchRequest:request error:&error];    

    //if (result.count == 1)
    //{
        if (((UICheckboxButton *)sender.object).checked)
        {
            //[self.workout addExercisesObject:(Exercise *)[result objectAtIndex:0]];
            [self.workout addExercisesObject:exercise];
            [self.workoutSet addObject:exercise];
        }
        else
        {
            [self.workout mutableOrderedSetValueForKey:@"exercises"];
            
            //[self.workout removeExercisesObject:(Exercise *)[result objectAtIndex:0]];
            [self.workout removeExercisesObject:exercise];
            [self.workoutSet removeObject:exercise];
        }
    //}
    //else
    //{
    //    NSLog(@"result.count: %d",result.count);
    //}
    
    NSLog(@"Exercise: %@ added to Workout: %@ count: %d", exercise.name,  
          self.workout.workout_name, self.workout.exercises.count);
    
    // Push changes
    [self.document.managedObjectContext save:nil];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
