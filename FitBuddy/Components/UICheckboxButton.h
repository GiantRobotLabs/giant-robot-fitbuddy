//
//  CheckboxLabel.h
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GymBuddyMacros.h"

@interface UICheckboxButton : UIButton

@property (nonatomic) BOOL checked;

-(void) setImageForValue: (BOOL) checked;

@end
