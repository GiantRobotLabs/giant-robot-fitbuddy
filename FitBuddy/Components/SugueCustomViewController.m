//
//  SugueCustomViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/16/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SugueCustomViewController.h"

@implementation SugueCustomViewController

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft

                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}

@end
