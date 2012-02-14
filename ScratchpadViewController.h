//
//  ScratchpadViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/13/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymBuddyMacros.h"
#import "LogbookEntry.h"

@interface ScratchpadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *scratchPad;
@property (nonatomic, strong) LogbookEntry *logbookEntry; 
@end
