//
//  WorkoutViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutViewController.h"
#import "Exercise.h"

@implementation WorkoutViewController
@synthesize buddyDatabase = _buddyDatabase;
@synthesize workoutTable = _workoutTable;

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.buddyDatabase.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil]; 
    NSLog(@"end setupFetchedResultsController");
}

- (void) loadData: (UIManagedDocument *) document
{
    Exercise *exercise = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Chest Press"];
    NSSortDescriptor *sortDescriptior = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending: YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptior];
    
    NSError *error = nil;
    NSArray *matches = [document.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))
    {
        // ERROR Condition
        NSLog(@"too many rows");
    } 
    else if ([matches count] == 0)
    {
        // Empty Table
        NSLog(@"empty table");
    } 
    else
    {
        NSLog(@"match");
        exercise = [matches lastObject];
    }
    NSLog(@"end loadData");
}

-(void) useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.buddyDatabase.fileURL path]]) {
        NSLog(@"file exists at path");
        [self.buddyDatabase saveToURL:self.buddyDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
             [self loadData:self.buddyDatabase];
             NSLog (@"created database");
         }];
    } else if (self.buddyDatabase.documentState == UIDocumentStateClosed) {
        [self.buddyDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self loadData:self.buddyDatabase];
            NSLog (@"opened database");
        }];
    } else if (self.buddyDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
        [self loadData:self.buddyDatabase];
    }
    
    NSLog(@"end useDocument");
}

-(void)setBuddyDatabase:(UIManagedDocument *)buddyDatabase
{
    if (_buddyDatabase != buddyDatabase)
    {
        _buddyDatabase = buddyDatabase;
        [self useDocument];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:nil];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    self.tableView = self.workoutTable;
    NSLog(@"set tableView");
    
    if (!self.buddyDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Database"];
        self.buddyDatabase = [[UIManagedDocument alloc]initWithFileURL:url];
        
        // Migrate Models
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.buddyDatabase.persistentStoreOptions = options;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Workout Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.textLabel setTextColor:([UIColor whiteColor])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = exercise.name;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:(22.0)];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    [cell.textLabel sizeToFit];
    [cell.contentView sizeToFit];
    
    return cell;
}

@end
