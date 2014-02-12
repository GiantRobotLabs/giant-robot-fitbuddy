//
//  LogbookViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"
#import "LogbookEntry.h"
#import "JBChartView.h"
#import "JBBarChartView.h"

@interface LogbookViewController : CoreDataTableController <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (nonatomic, strong) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet JBBarChartView *chartView;

@end
