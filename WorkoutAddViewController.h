//
//  WorkoutAddViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutAddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *workoutNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;

@end
