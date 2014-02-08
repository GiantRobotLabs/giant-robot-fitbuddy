//
//  LogbookViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "LogbookEntry.h"

@interface LogbookViewController : CoreDataTableViewController

@property (nonatomic, strong) LogbookEntry *logbookEntry;
@property (nonatomic, strong) UIManagedDocument *document;

@end
