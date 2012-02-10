//
//  WorkoutViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataTableController.h"

@interface WorkoutViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITableView *workoutTable;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;

@end