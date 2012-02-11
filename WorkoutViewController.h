//
//  WorkoutViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"

@interface WorkoutViewController : CoreDataTableController

@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;

@property (strong, nonatomic) UIManagedDocument *document;

@end