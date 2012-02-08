//
//  WorkoutAddViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutAddViewController.h"

@implementation WorkoutAddViewController
@synthesize workoutNameTextField;
@synthesize workoutTableView;

-(void) viewDidAppear:(BOOL)animated
{
    [self.workoutNameTextField addTarget:self
                       action:@selector(workoutNameTextFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) workoutNameTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
    NSLog(@"resign");
}

- (void)viewDidUnload {
    [self setWorkoutNameTextField:nil];
    [self setWorkoutTableView:nil];
    [super viewDidUnload];
}
@end
