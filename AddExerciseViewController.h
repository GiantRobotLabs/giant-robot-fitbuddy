//
//  AddExerciseViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface AddExerciseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addExerciseField;

@property (nonatomic, strong) Exercise *exercise;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
