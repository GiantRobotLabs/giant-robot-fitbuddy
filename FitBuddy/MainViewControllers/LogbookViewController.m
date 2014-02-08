//
//  LogbookViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "LogbookViewController.h"
#import "LogbookEntry.h"
#import "Workout.h"
#import "GymBuddyAppDelegate.h"
#import "CoreDataHelper.h"

@implementation LogbookViewController

@synthesize logbookEntry = _logbookEntry;
@synthesize document = _document;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    
}

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"completed = %@", [NSNumber numberWithBool:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext: [[GymBuddyAppDelegate sharedAppDelegate]managedObjectContext]
                                                                          sectionNameKeyPath:@"date_t" 
                                                                                   cacheName:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Logbook Cell"];
    UILabel *exerciseLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *workoutLabel = (UILabel *) [cell viewWithTag:101];
    UIImageView *exerciseIcon = (UIImageView *) [cell viewWithTag:102];
    UILabel *qstatValue = (UILabel *) [cell viewWithTag:103];
    UILabel *qstatLabel = (UILabel *) [cell viewWithTag:104];
    
    // Add the data to the cell
    LogbookEntry *logbookEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    exerciseLabel.text = logbookEntry.exercise_name;
    workoutLabel.text = logbookEntry.workout_name;
    
    if (logbookEntry.pace || logbookEntry.distance || logbookEntry.duration)
    {
        exerciseIcon.image = [UIImage imageNamed:kCARDIO];
        qstatLabel.text = @"Pace";
        qstatValue.text = logbookEntry.pace;
    }
    else
    {
        exerciseIcon.image = [UIImage imageNamed:kRESISTANCE];
        qstatLabel.text = @"Weight";
        qstatValue.text = logbookEntry.weight;
    }
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if (DEBUG) NSLog(@"Segue: %@", segue.identifier);
    
    LogbookEntry *entry = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if ([segue.destinationViewController respondsToSelector:@selector(setLogbookEntry:)]) {
        [segue.destinationViewController performSelector:@selector(setLogbookEntry:) withObject:entry];
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return YES to edit
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
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
            LogbookEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext deleteObject:entry];
        }
    }    
}

-(NSString *) convertRawToShortDateString: (NSString *) rawDateStr
{
    // Convert rawDateStr string to NSDate...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
    NSDate *date = [formatter dateFromString:rawDateStr];
    
    // Convert NSDate to format we want...
    [formatter setDateFormat:@"dd MMMM yyyy"];
    NSString *formattedDateStr = [formatter stringFromDate:date];
    return formattedDateStr;  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
    [labelView setBackgroundColor: kCOLOR_GRAY];
    [labelView setAutoresizesSubviews:TRUE];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 60.0)];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = [self convertRawToShortDateString:sectionTitle];
    [label setTextColor: [UIColor whiteColor]];

    [labelView addSubview:label];
    
 //   NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeRight multiplier:1.0 constant:20];
    
 //   [tableView addConstraint:c];
    
    return labelView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

@end
