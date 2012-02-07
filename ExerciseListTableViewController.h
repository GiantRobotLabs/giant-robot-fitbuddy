//
//  ExerciseListTableViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface ExerciseListTableViewController : CoreDataTableViewController

@property (strong, nonatomic) UIManagedDocument *buddyDatabase;
@property (strong, nonatomic) UISwipeGestureRecognizer *tableViewSwiper;

@end
