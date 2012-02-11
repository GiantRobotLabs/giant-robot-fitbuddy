//
//  WorkoutViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutViewController.h"
#import "CoreDataHelper.h"
#import "Workout.h"

@implementation WorkoutViewController 
@synthesize workoutTableView = _workoutTable;

@synthesize document = _document;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:YES]];
    
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

-(void) viewWillAppear:(BOOL)animated
{
    // Setup and initialize
    self.tableView = self.workoutTableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    self.workoutTableView.backgroundColor = [UIColor clearColor];
    
    // Initialize view
    [self loadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Get the Prototypes
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    // Visual stuff
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
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
            UITableViewCell *cell = [self.workoutTableView cellForRowAtIndexPath:indexPath];
            
            //Update the cell or model 
            cell.editing = YES;
            Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.document.managedObjectContext deleteObject:workout];
        }
        [self performFetch];
        [self.workoutTableView reloadData];
    }    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.workoutTableView indexPathForCell:sender];
    Workout *workout = nil;
    if ([segue.identifier isEqualToString: (@"Add Workout Segue")])
    {
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:self.document.managedObjectContext];
    }
    else
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:workout];
    }
    [self loadData];
}


@end
