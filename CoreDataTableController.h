//
//  CoreDataTableController.h
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
