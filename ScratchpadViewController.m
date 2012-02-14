//
//  ScratchpadViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/13/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "ScratchpadViewController.h"

@implementation ScratchpadViewController

@synthesize scratchPad;
@synthesize logbookEntry = _logbookEntry;


-(void) viewDidAppear:(BOOL)animated
{
    self.scratchPad.text = [NSString stringWithFormat:@"%@", self.logbookEntry];
}

- (void)viewDidUnload {
    [self setScratchPad:nil];
    [super viewDidUnload];
}
@end
