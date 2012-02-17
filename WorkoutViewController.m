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

#pragma mark -
#pragma mark UI Components
@synthesize editButton = _editButton;
@synthesize startButton = _startButton;
@synthesize edit = _edit;

#pragma mark CoreData
@synthesize document = _document;

#pragma mark -
#pragma mark Initialization

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:[CoreDataHelper getActiveManagedObjectContext] 
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
    //[CoreDataHelper callSave:self.document.managedObjectContext];
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.startButton setBackgroundImage:[UIImage imageNamed:BUTTON_IMAGE_DARK_LG] forState:UIControlStateDisabled];
    [self.startButton setBackgroundImage:[UIImage imageNamed:BUTTON_IMAGE_LG] forState:UIControlStateNormal];
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
       // [self setupFetchedResultsController];
    }
    
    if (DEBUG) NSLog(@"View will appear");
}

#pragma mark -
#pragma mark TableView Implementations

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Get the Prototypes
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:200];
    
    // Visual stuff
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    cell.editingAccessoryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    
    // Add the data to the cell
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = workout.workout_name;
    
    if (workout.logbookEntries.count == 0) dateLabel.text = @"never";
    else
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd MMM yyyy HH:mm"];
        dateLabel.text = [format stringFromDate:
                          ((LogbookEntry *)[workout.logbookEntries lastObject]).date];
    }
    
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
            [[CoreDataHelper getActiveManagedObjectContext] deleteObject:workout];
        }
        
        //[CoreDataHelper callSave:self.document.managedObjectContext];
        [self enableButtons:NO];
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

#pragma mark -
#pragma mark UI Actions

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

- (IBAction)startButtonPressed:(UIButton *)sender 
{
    if (((Workout *)[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]]).exercises.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"There are no exercises for this workout."
                              message: @"Edit this workout to add some exercises to log. Then come back and start workout mode."
                              delegate: nil
                              cancelButtonTitle:@"Got it!"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self performSegueWithIdentifier:START_WORKOUT_SEGUE sender:sender];
    }
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Workout *workout = nil;
    
    if ([segue.identifier isEqualToString: (ADD_WORKOUT_SEGUE)])
    {
        workout = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_TABLE
                                                inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
    }
    else if ([segue.identifier isEqualToString:START_WORKOUT_SEGUE])
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [((WorkoutModeViewController *)[segue.destinationViewController topViewController]) initialSetupOfFormWithWorkout: workout];
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


- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
}
@end
