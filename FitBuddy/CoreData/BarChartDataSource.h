//
//  BarChartDataSource.h
//  FitBuddy
//
//  Created by john.neyer on 2/13/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JBChartView.h"
#import "JBBarChartView.h"

@interface BarChartDataSource : NSObject <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resistanceHistoryController;
@property (nonatomic, strong) NSFetchedResultsController *cardioHistoryController;
@property (nonatomic, strong) NSMutableDictionary *cardioDataSource;
@property (nonatomic, strong) NSMutableDictionary *resistanceDataSource;

- (BOOL) buildHistoryArrays;
- (BOOL) load;

@end
