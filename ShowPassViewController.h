//
//  ShowPassViewController.h
//  GymPass
//
//  Created by john.neyer on 4/18/14.
//  Copyright (c) 2014 John Neyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPassViewController : UIViewController

- (IBAction)infoButtonPressed:(id)sender;

@property NSString *memberName;
@property NSString *memberId;
@property NSString *venueName;

@end
