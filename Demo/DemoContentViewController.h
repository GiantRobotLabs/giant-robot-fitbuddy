//
//  DemoContentViewController.h
//  FitBuddy
//
//  Created by john.neyer on 2/15/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@end
