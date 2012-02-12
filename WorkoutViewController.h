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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) UIManagedDocument *document;
@property BOOL edit;

-(void) enableButtons: (BOOL) enable;
@end