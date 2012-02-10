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
#import "CoreDataTableViewController.h"

@interface WorkoutViewController()
@property (nonatomic) BOOL beganUpdates;
@end


@implementation WorkoutViewController 

@synthesize document = _document;

@synthesize workoutTable = _workoutTable;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                         managedObjectContext:self.document.managedObjectContext 
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

-(void) loadData
{

}

-(void) viewWillAppear:(BOOL)animated
{
    // Setup and initialize
    [super viewWillAppear:animated];
    self.workoutTable.delegate = self;
    self.workoutTable.dataSource = self;
    
    // Setup the database
    if (!self.document)
    {
        [CoreDataHelper openDatabase:@"GymBuddy" usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
            NSLog(@"Database block completed");
        }];
    } 
    else
    {
        [self setupFetchedResultsController];
    }
    
    // Visual stuff
    self.navigationItem.title = nil;
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    self.workoutTable.backgroundColor = [UIColor clearColor];
   
    // Initialize the view
    [self loadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Workout Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.textLabel setTextColor:([UIColor whiteColor])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Visual stuff
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
    // Add the data to the cell
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workout.workout_name;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:(22.0)];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    [cell.textLabel sizeToFit];
    [cell.contentView sizeToFit];
    
    return cell;
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.workoutTable reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            //self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch]; 
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.workoutTable reloadData];
        }
    }
}

// UITableViewDataSource Support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.workoutTable indexPathForCell:sender];
    Workout *workout = nil;
    NSLog(@"segue: %@", segue.identifier);
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
}

@end
