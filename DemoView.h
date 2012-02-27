//
//  DemoView.h
//  GymBuddy
//
//  Created by John Neyer on 2/23/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoView : UIViewController

@property (weak, nonatomic) IBOutlet UIPageControl *demoPageControl;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swiper;
@property (weak, nonatomic) IBOutlet UIImageView *imagePanel;

@property (strong, nonatomic) NSString *returnSegue;

@end
