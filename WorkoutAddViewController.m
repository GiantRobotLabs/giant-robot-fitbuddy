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
    
    // Setup the database
    if (!self.document)
    {
        [CoreDataHelper openDatabase:@"GymBuddy" usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
            NSLog(@"Database block completed");
        }];
    } 
    else
    {
        [self setupFetchedResultsController];
    }
    
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
    NSLog(@"resign");
}

- (void) newExerciseTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
    NSLog(@"resign");
}

- (IBAction)addWorkout:(UITextField *)sender {
    self.workout.workout_name = sender.text;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([self.workoutNameTextField.text isEqualToString:@""]) 
    {
        [self.workout.managedObjectContext deleteObject:self.workout];
        NSLog(@"Deleting object");
    }    
}

-(void)setDocument:(UIManagedDocument *) document
{
    if (_document != document)
    {
        _document = document;
        [self setupFetchedResultsController];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Workout Exercise Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.textLabel setTextColor:([UIColor whiteColor])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Visual stuff
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = exercise.name;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:(22.0)];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    [cell.textLabel sizeToFit];
    [cell.contentView sizeToFit];
    
    return cell;
}


@end
