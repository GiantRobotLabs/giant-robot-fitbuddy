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
@synthesize tableViewSwiper = _tableViewSwiper;

-(void) setupFetchedResultsController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Visual stuff
    [self.navigationItem setTitle:nil];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    
    // Setup the database
    if (!self.document)
    {
        [CoreDataHelper openDatabase:@"GymBuddy" usingBlock:^(UIManagedDocument *doc) {
            self.document = doc;
        }];
    }  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Exercise Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    // Visual stuff
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-cell.png"]];
    
    // Add the data to the cell
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    label.text = exercise.name;
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Exercise *exercise = nil;
    NSLog(@"segue: %@", segue.identifier);
    if ([segue.identifier isEqualToString: (@"Add Exercise Segue")])
    {
        exercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:self.document.managedObjectContext];
    }
    else
    {
       exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:exercise];
    }
}

- (void) removeTableViewEditRecognizer
{
    if (self.tableViewSwiper != nil)
    {
        [self.tableView removeGestureRecognizer: self.tableViewSwiper];
        self.tableViewSwiper = nil;
    }
}

- (void) addTableViewEditRecognizer
{
    if (self.tableViewSwiper == nil)
    {
        //Add a left swipe gesture recognizer
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector (handleSwipeLeft:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.tableView addGestureRecognizer:recognizer];
        self.tableViewSwiper = recognizer;
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableViewSwiper == nil)
    {
        [self addTableViewEditRecognizer];
        [sender setTintColor:([UIColor redColor])];
    }
    else
    {
        [self removeTableViewEditRecognizer];
        [sender setTintColor:([UIColor blackColor])];
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //Check if index path is valid
    if(indexPath)
    {
        //Get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //Update the cell or model 
        cell.editing = YES;
        Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.document.managedObjectContext deleteObject:exercise];
    }
        
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
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
            [self.document.managedObjectContext deleteObject:exercise];
        }
    }    
}

@end