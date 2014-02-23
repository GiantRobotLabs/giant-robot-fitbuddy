//
//  DemoViewController.h
//  FitBuddy
//
//  Created by john.neyer on 2/15/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoContentViewController.h"

@interface DemoViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)closeDemo:(UIButton *)sender;


@end
