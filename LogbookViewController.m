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

@implementation LogbookViewController

@synthesize logbookEntry = _logbookEntry;
@synthesize document = _document;

-(void) setupFetchedResultsController
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(compare:)]];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                            managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                              sectionNameKeyPath:nil 
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
    //[self.document.managedObjectContext save:nil];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Logbook Cell"];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *workoutLabel = (UILabel *) [cell viewWithTag:101];
    
    // Visual stuff
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CELL_IMAGE]];
    
    // Add the data to the cell
    LogbookEntry *logbookEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yyyy HH:mm"];
    dateLabel.text = [format stringFromDate: logbookEntry.date];
    workoutLabel.text = logbookEntry.workout_name;
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (DEBUG) NSLog(@"Segue: %@", segue.identifier);
    
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
        
        //[self.document.managedObjectContext save:nil];
    }    
}



-(void) viewWillDisappear:(BOOL)animated 
{
    //[self.document.managedObjectContext save:nil];
}

@end
