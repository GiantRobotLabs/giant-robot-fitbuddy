//
//  ExerciseListTableViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "ExerciseListTableViewController.h"
#import "Exercise.h"
#import "CoreDataHelper.h"

@implementation ExerciseListTableViewController

@synthesize document = _document;
@synthesize workout = _workout;
@synthesize addButton = _addButton;

-(void) setupFetchedResultsController
{
    if (self.workout) 
    {
    
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name IN %@", [self.workout.exercises mutableArrayValueForKey:@"name"]];
        NSLog(@"%@", [self.workout.exercises mutableArrayValueForKey:@"name"]);
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                            managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                              sectionNameKeyPath:nil 
                                                                                       cacheName:nil];
    }
    else
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                            managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                              sectionNameKeyPath:nil 
                                                                                       cacheName:nil];
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

-(void)setWorkout:(Workout *)workout
{
    _workout = workout;
    
    self.navigationItem.rightBarButtonItem = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Visual stuff    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    
    // Setup the database
    if (!self.document)
    {
        [CoreDataHelper openDatabase:DATABASE usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
        }];
    }  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    // Visual stuff
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];

    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Exercise *exercise = nil;
    
    if (DEBUG) NSLog(@"Segue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString: (ADD_EXERCISE_SEGUE)])
    {
        exercise = [NSEntityDescription insertNewObjectForEntityForName:EXERCISE_TABLE inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
    }
    else
    {
       exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:exercise];
    }
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
            Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[CoreDataHelper getActiveManagedObjectContext] deleteObject:exercise];
        }
        
        //[CoreDataHelper callSave:self.document.managedObjectContext];
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[CoreDataHelper callSave:self.document.managedObjectContext];
    
}
@end