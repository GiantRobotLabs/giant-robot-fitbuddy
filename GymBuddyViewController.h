//
//  GymBuddyViewController.h
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "Workout.h"
#import "CoreDataTableViewController.h"

@interface GymBuddyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightIncrementLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (nonatomic, strong) Exercise *exercise;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void) loadDataFromExerciseObject;

@end
