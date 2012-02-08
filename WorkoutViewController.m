//
//  WorkoutViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutViewController.h"

@implementation WorkoutViewController
@synthesize workoutTable;

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:nil];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"gb-title.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gb-background.png"]];
    
}

- (void)viewDidUnload {
    [self setWorkoutTable:nil];
    [super viewDidUnload];
}
@end
