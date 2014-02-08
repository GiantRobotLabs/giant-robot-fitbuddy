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
#import "GymBuddyMacros.h"
#import "GymBuddyAppDelegate.h"

@implementation WorkoutViewController 

#pragma mark -
#pragma mark UI Components
@synthesize editButton = _editButton;
@synthesize startButton = _startButton;
@synthesize edit = _edit;

#pragma mark CoreData
@synthesize context = _context;

#pragma mark -
#pragma mark Initialization

-(void) setupFetchedResultsController
{
    self.context = [GymBuddyAppDelegate sharedAppDelegate].managedObjectContext;
    [self setupFetchedResultsControllerWithContext:self.context];
    
}

-(void) setupFetchedResultsControllerWithContext: (NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

-(void) initializeDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults stringForKey:@"Cardio Increment"])
        [defaults setValue:@"0.5" forKey:@"Cardio Increment"];
        
    if (![defaults stringForKey:@"Resistance Increment"]) 
        [defaults setValue:@"2.5" forKey:@"Resistance Increment"];
        
    if (![defaults stringForKey:@"Use iCloud"]) 
        [defaults setValue:@"No" forKey:@"Use iCloud"];
    
    if (![defaults stringForKey:@"firstrun"])
        [defaults setObject:@"0" forKey:@"firstrun"];
}

-(void) viewDidLoad
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    [self setupFetchedResultsController];

}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self initializeDefaults];

    // Visual stuff
    [self.startButton setBackgroundImage:[UIImage imageNamed:kSTARTDISABLED] forState:UIControlStateDisabled];
    [self.startButton setBackgroundImage:[UIImage imageNamed:kSTART] forState:UIControlStateNormal];
    [self enableButtons:NO];
    
}

#pragma mark -
#pragma mark TableView Implementations

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DEBUG) NSLog(@"Building cell");
    
    // Get the Prototypes
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Workout Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:200];

    // Add the data to the cell
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = workout.workout_name;
    
    if (workout.logbookEntries.count == 0) dateLabel.text = @"never";
    else
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd MMM yyyy"];
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
            
            [self.context deleteObject:workout];
            [[GymBuddyAppDelegate sharedAppDelegate] saveContext];
        }
        
        [self enableButtons:NO];
    }    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self enableButtons:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self enableButtons:NO];
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
        self.editButton.tintColor = [UIColor whiteColor];
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
    
    if (DEBUG) NSLog(@"In prepare for segue");
    if ([segue.identifier isEqualToString: (ADD_WORKOUT_SEGUE)])
    {
        NSLog(@"In add workout segue");
        workout = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_TABLE
                                                inManagedObjectContext:self.context];
    }
    else if ([segue.identifier isEqualToString:START_WORKOUT_SEGUE])
    {
        NSLog(@"In start workout segue");
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [((WorkoutModeViewController *)[segue.destinationViewController topViewController]) initialSetupOfFormWithWorkout: workout];
    }
    else
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //if (DEBUG) NSLog(@"Before Segue for Workout:%@", workout.workout_name);
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
