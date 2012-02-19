//
//  SettingsIncrementViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsIncrementViewController : UITableViewController

@property (nonatomic, strong) NSUserDefaults *defaults;
@property  (nonatomic, strong) NSString *defaultsKey;

@end
