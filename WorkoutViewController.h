//
//  WorkoutViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@interface WorkoutViewController : CoreDataViewController

@property (strong, nonatomic) UIManagedDocument *buddyDatabase;
@property (weak, nonatomic) IBOutlet UITableView *workoutTable;

@end