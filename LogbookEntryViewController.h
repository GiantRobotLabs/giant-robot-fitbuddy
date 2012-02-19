//
//  LogbookEntryViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogbookEntry+TDate.h"

@interface LogbookEntryViewController : UIViewController

@property (nonatomic, strong) LogbookEntry *logbookEntry; 
@property (weak, nonatomic) IBOutlet UILabel *entryDate;
@property (weak, nonatomic) IBOutlet UILabel *entryName;
@property (weak, nonatomic) IBOutlet UILabel *slotOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colOneDate;
@property (weak, nonatomic) IBOutlet UILabel *colTwoDate;
@property (weak, nonatomic) IBOutlet UILabel *slotOneColOne;
@property (weak, nonatomic) IBOutlet UILabel *slotTwoColOne;
@property (weak, nonatomic) IBOutlet UILabel *slotThreeColOne;
@property (weak, nonatomic) IBOutlet UILabel *slotOneColTwo;
@property (weak, nonatomic) IBOutlet UILabel *slotTwoColTwo;
@property (weak, nonatomic) IBOutlet UILabel *slotThreeColTwo;

@end
