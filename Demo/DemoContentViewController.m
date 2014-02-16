//
//  DemoContentViewController.m
//  FitBuddy
//
//  Created by john.neyer on 2/15/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "DemoContentViewController.h"

@interface DemoContentViewController ()

@end

@implementation DemoContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
