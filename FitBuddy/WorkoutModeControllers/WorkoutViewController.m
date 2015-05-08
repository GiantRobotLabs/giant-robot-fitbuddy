//
//  WorkoutViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutViewController.h"
#import "WorkoutModeParentController2.h"
#import "CoreDataHelper.h"
#import "FitBuddyMacros.h"

@implementation WorkoutViewController 

#pragma mark -
#pragma mark UI Components
@synthesize editButton = _editButton;
@synthesize startButton = _startButton;
@synthesize edit = _edit;

#pragma mark CoreData

#pragma mark -
#pragma mark Initialization

-(void) setupFetchedResultsController
{
    [self setupFetchedResultsControllerWithContext:[AppDelegate sharedAppDelegate].managedObjectContext];
}

-(void) setupFetchedResultsControllerWithContext: (NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_TABLE];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"last_workout" ascending:NO]];
    
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
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self initializeDefaults];
    [self setupFetchedResultsController];

    // Visual stuff
    [self.startButton setBackgroundImage:[UIImage imageNamed:kSTARTDISABLED] forState:UIControlStateDisabled];
    [self.startButton setBackgroundImage:[UIImage imageNamed:kSTART] forState:UIControlStateNormal];
    [self enableButtons:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupFetchedResultsController) name:kUBIQUITYCHANGED object:[AppDelegate sharedAppDelegate].coreDataConnection];
   
    /*
    NSArray *vcArray = [self.tabBarController viewControllers];
    NSMutableArray *newArray = [[self.tabBarController viewControllers] mutableCopy];
    
    for (UIViewController *vc in vcArray)
    {
        if ([vc.tabBarItem.title isEqualToString:@"GymPass"])
        {
            [newArray removeObject:vc];
        }
    }
    
    [self.tabBarController setViewControllers:newArray];
     */

    
    [super viewWillAppear:animated];
    
}

#pragma mark -
#pragma mark TableView Implementations

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yyyy"];
    
    if (workout.last_workout)
    {
        dateLabel.text = [format stringFromDate: workout.last_workout];
    }
    else
    {
        if (workout.logbookEntries.count == 0)
        {
            dateLabel.text = @"never";
        }
        else
        {
            // Old last date
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                         ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [workout.logbookEntries sortedArrayUsingDescriptors:sortDescriptors];
            
            NSDate *lastDate =  ((LogbookEntry *)sortedArray[0]).date;
            dateLabel.text = [format stringFromDate: lastDate];
            workout.last_workout = lastDate;
        }
    }
    
    return cell;
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
            
            [[AppDelegate sharedAppDelegate].managedObjectContext deleteObject:workout];
            [[AppDelegate sharedAppDelegate].managedObjectContext save:nil];
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
                                                inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:START_WORKOUT_SEGUE])
    {
        NSLog(@"In start workout segue");
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [((WorkoutModeParentController2 *)[segue.destinationViewController topViewController]) setWorkout:workout];
    }
    else
    {
        workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) 
    {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:workout];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
    [labelView setBackgroundColor: [UIColor whiteColor]];
    [labelView setAutoresizesSubviews:TRUE];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 60.0)];
    label.text = @"WORKOUTS";
    label.font = [UIFont systemFontOfSize:14.0];
    [label setTextColor: kCOLOR_DKGRAY];
    
    [labelView addSubview:label];
    
    return labelView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Workouts";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - reordering

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}
- (void) setOrderFromCells
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
    
}

- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setStartButton:nil];
    
    [super viewDidUnload];
}
@end
