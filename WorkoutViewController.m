//
//  WorkoutViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutViewController.h"
#import "WorkoutModeViewController.h"
#import "CoreDataHelper.h"
#import "Workout.h"

@implementation WorkoutViewController 

@synthesize editButton = _editButton;
@synthesize startButton = _startButton;
@synthesize document = _document;
@synthesize edit = _edit;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

-(void) setDocument:(UIManagedDocument *)document
{
    if (!self.document)
    {
        _document = document;
    }
    
    [self setupFetchedResultsController];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Setup and initialize
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.startButton setBackgroundImage:[UIImage imageNamed:BUTTON_IMAGE_DARK] forState:UIControlStateDisabled];
    [self.startButton setBackgroundImage:[UIImage imageNamed:BUTTON_IMAGE] forState:UIControlStateNormal];
    [self enableButtons:NO];
    
    // Initialize view    
    if (!self.document)    
    {
        [CoreDataHelper openDatabase:DATABASE usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
        }]; 
    }
    else
    {
        [self setupFetchedResultsController];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Get the Prototypes
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    // Visual stuff
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    cell.editingAccessoryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    
    // Add the data to the cell
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = workout.workout_name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return YES to edit
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        //Check if index path is valid
        if(indexPath)
        {
            //Get the cell out of the table view
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            //Update the cell or model 
            cell.editing = YES;
            Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.document.managedObjectContext deleteObject:workout];
        }
        //[self performFetch];
        [self.document.managedObjectContext save:nil];
        [self.tableView reloadData];
        
        [self enableButtons:NO];
    }    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Workout *workout = nil;
    
    if ([segue.identifier isEqualToString: (ADD_WORKOUT_SEGUE)])
    {
        workout = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_TABLE
                                                inManagedObjectContext:self.document.managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:START_WORKOUT_SEGUE])
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ((WorkoutModeViewController *)[segue.destinationViewController topViewController]).workout = workout;
    }
    else
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (DEBUG) NSLog(@"Before Segue for Workout:%@", workout.workout_name);
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) 
    {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:workout];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self enableButtons:YES];
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self enableButtons:NO];
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
}

-(void) enableButtons: (BOOL) enable
{
    self.editButton.enabled = enable;
    self.startButton.enabled = enable;
    
    if (enable)
    {
        self.startButton.titleLabel.text = @"Start";
        self.editButton.tintColor = [UIColor blackColor];
    }
    else
    {
        self.startButton.titleLabel.text = @"";
        self.editButton.tintColor = [UIColor clearColor];

    }
}

- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
}
@end
