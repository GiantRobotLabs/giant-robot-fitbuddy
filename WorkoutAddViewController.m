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

@implementation WorkoutAddViewController
@synthesize workoutNameTextField;
@synthesize workoutTableView;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize document = _document;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil]; 
}

-(void) loadData
{
    if (!self.document)    
    {
        [CoreDataHelper openDatabase:@"GymBuddy" usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
        }]; 
    }
    else
    {
       [self setupFetchedResultsController];
    }
}

-(void) setDocument:(UIManagedDocument *)document
{
    if (!self.document)
    {
        _document = document;
    }
    
    [self setupFetchedResultsController];
}

-(void) viewDidAppear:(BOOL)animated
{
    // Setup and initialize
    self.tableView = self.workoutTableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.workoutNameTextField addTarget:self
                       action:@selector(workoutNameTextFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    self.workoutTableView.backgroundColor = [UIColor clearColor];
    
    // Initialize the view
    [self loadData];

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
    if ([self.workoutNameTextField.text isEqualToString:@""]) 
    {
        [self.workout.managedObjectContext deleteObject:self.workout];
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
    checkbox.exerciseObject = exercise;
    checkbox.workoutObject = self.workout;
    
    return cell;
}

- (void)checkboxClicked:(UICheckboxButton *)sender 
{
    Exercise *value = (Exercise *)sender.exerciseObject;
    NSLog(@"Clicky: %@", value.name);
}

@end
