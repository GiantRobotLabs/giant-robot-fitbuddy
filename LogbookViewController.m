//
//  LogbookViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "LogbookViewController.h"
#import "LogbookEntry.h"
#import "CoreDataHelper.h"
#import "Workout.h"

@implementation LogbookViewController

@synthesize logbookEntry = _logbookEntry;
@synthesize document = _document;

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"completed = %@", [NSNumber numberWithBool:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                          sectionNameKeyPath:@"date_t" 
                                                                                   cacheName:nil];
}

-(void)setDocument:(UIManagedDocument *) document
{
    if (_document != document)
    {
        _document = document;
        [self setupFetchedResultsController];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Visual stuff    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:TITLEBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    self.searchDisplayController.searchBar.tintColor = [UIColor clearColor];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Logbook Cell"];
    UILabel *exerciseLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *workoutLabel = (UILabel *) [cell viewWithTag:101];
    UIImageView *exerciseIcon = (UIImageView *) [cell viewWithTag:102];
    UILabel *qstatValue = (UILabel *) [cell viewWithTag:103];
    UILabel *qstatLabel = (UILabel *) [cell viewWithTag:104];
    
    // Visual stuff
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    cell.backgroundView = bgView;
    
    // Add the data to the cell
    LogbookEntry *logbookEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    exerciseLabel.text = logbookEntry.exercise_name;
    workoutLabel.text = logbookEntry.workout_name;
    
    if (logbookEntry.pace || logbookEntry.distance || logbookEntry.duration)
    {
        exerciseIcon.image = [UIImage imageNamed:GB_CARDIO_IMAGE];
        qstatLabel.text = @"Pace";
        qstatValue.text = logbookEntry.pace;
    }
    else
    {
        exerciseIcon.image = [UIImage imageNamed:GB_RESISTANCE_IMAGE];
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
    [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].backgroundColor = [UIColor clearColor];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return YES to edit
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
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
            [[CoreDataHelper getActiveManagedObjectContext] deleteObject:entry];
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
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 320, 25);
    label.backgroundColor = GYMBUDDY_DK_BROWN;
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = [self convertRawToShortDateString:sectionTitle];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [view addSubview:label];
    
    return view;
}

@end
