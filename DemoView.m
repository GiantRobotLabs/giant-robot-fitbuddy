//
//  DemoView.m
//  GymBuddy
//
//  Created by John Neyer on 2/23/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "DemoView.h"

@implementation DemoView
@synthesize demoPageControl = _demoPageControl;
@synthesize swiper = _swiper;
@synthesize imagePanel = _imagePanel;
@synthesize returnSegue = _returnSegue;

NSArray *images;

-(void) loadPage
{
    NSString *str = [images objectAtIndex:self.demoPageControl.currentPage];
    self.imagePanel.image = [UIImage imageNamed:str];
}

- (void)viewDidLoad
{
    images = [NSArray arrayWithObjects:@"demo1.png", @"demo2.png", @"demo3.png", @"demo4.png",
     @"demo5.png", @"demo6.png", @"demo7.png", @"demo8.png", @"demo9.png", nil];
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];
    
    // Set the back swiper
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleReverseSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:recognizer];
    
    self.returnSegue = @"Return Segue";
    
    self.demoPageControl.numberOfPages = images.count;
    [self loadPage];
}

- (IBAction)handleSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    int currPage = self.demoPageControl.currentPage;
    int numPages = self.demoPageControl.numberOfPages;
    
    if (currPage == numPages - 1)
        [self performSegueWithIdentifier:self.returnSegue sender:self];
    else
        currPage += 1;
    
    self.demoPageControl.currentPage = currPage;
    [self loadPage];
}

- (IBAction)handleReverseSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    int currPage = self.demoPageControl.currentPage;
    
    if (currPage > 0)
        currPage -= 1;
    
    self.demoPageControl.currentPage = currPage;
    [self loadPage];
}

- (void)viewDidUnload {
    [self setDemoPageControl:nil];
    [self setSwiper:nil];
    [self setImagePanel:nil];
    [super viewDidUnload];
}
@end
