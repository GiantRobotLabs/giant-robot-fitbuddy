//
//  ExerciseListTableViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "ExerciseListTableViewController.h"
#import "CoreDataHelper.h"
#import "FitBuddyMacros.h"

#import "FitBuddy-Swift.h"

@implementation ExerciseListTableViewController

@synthesize document = _document;
@synthesize addButton = _addButton;

-(void) setupFetchedResultsController
{
    NSManagedObjectContext *context = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupFetchedResultsController) name:kUBIQUITYCHANGED object:[AppDelegate sharedAppDelegate].coreDataConnection];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (DEBUG) NSLog(@"Building exercise cell");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:102];
    

    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    
    NSEntityDescription *desc = exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        icon.image = [UIImage imageNamed:kCARDIO];
    }
    else
    {
        icon.image = [UIImage imageNamed:kRESISTANCE];
    }
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Exercise *exercise = nil;
    
    SEL setExerciseSelector = sel_registerName("setExercise:");
        
    //if (DEBUG) NSLog(@"Segue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString: (ADD_EXERCISE_SEGUE)])
    {
        // Do nothing
    }
    else
    {
       exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([segue.destinationViewController respondsToSelector:setExerciseSelector]) {
        
        [segue.destinationViewController performSelector:setExerciseSelector withObject:exercise];
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
            [[[AppDelegate sharedAppDelegate] managedObjectContext] deleteObject:exercise];
        }
    }    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
    [labelView setBackgroundColor: kCOLOR_LTGRAY];
    [labelView setAutoresizesSubviews:TRUE];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 60.0)];
    label.text = @"EXERCISES";
    label.font = [UIFont systemFontOfSize:14.0];
    [label setTextColor: kCOLOR_DKGRAY];
    
    [labelView addSubview:label];
    
    return labelView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Exercises";
}

-(void) viewWillDisappear:(BOOL)animated
{
}

@end