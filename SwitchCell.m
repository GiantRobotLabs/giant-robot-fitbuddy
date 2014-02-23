//
//  SwitchCell.m
//  FitBuddy
//
//  Created by john.neyer on 1/26/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "SwitchCell.h"
#import "FitBuddyMacros.h"

@implementation SwitchCell

- (void)switched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHECKBOXTOGGLED object:self];
}



@end
