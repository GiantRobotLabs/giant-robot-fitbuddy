//
//  LogbookViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"
#import "JBChartView.h"
#import "JBBarChartView.h"

#import "FitBuddy-Swift.h"

@import FitBuddyModel;

@interface LogbookViewController : CoreDataTableController

@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (strong, nonatomic) IBOutlet UIView *chartView;


@end
