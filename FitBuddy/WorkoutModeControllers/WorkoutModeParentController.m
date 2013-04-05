//
//  WorkoutModeParentController.m
//  GymBuddy
//
//  Created by John Neyer on 8/8/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeParentController.h"
#import "WorkoutModeViewController.h"

@interface WorkoutModeParentController ()

@property (assign) BOOL rotating;
@property (assign) NSUInteger page;
@property (assign) BOOL pageControlUsed;

-(void) loadScrollViewWithPage:(int)page;

@end

NSMutableOrderedSet *skippedEntries;
NSMutableOrderedSet *logbookEntries;

@implementation WorkoutModeParentController

@synthesize workout = _workout;
@synthesize exercise = _extercise;
@synthesize firstPage = _firstPage;
@synthesize lastPage = _lastPage;
@synthesize pageControl = _pageControl;
@synthesize scrollView = _scrollView;
@synthesize progressBar = _progressBar;
@synthesize finishButton = _finishButton;
@synthesize notesButton = _notesButton;
@synthesize skipitButton = _skipitButton;
@synthesize logitButton = _logitButton;
@synthesize toolbar = _toolbar;
@synthesize workoutLabel = _workoutLabel;

@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize rotating = _rotating;


-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.pageControl setEnabled:YES];
    
    [self setupViews];
}

-(void) setupViews {
    
    for (Exercise *e in self.workout.exercises)
    {    
        WorkoutModeViewController *wmvc = 
        [self.storyboard instantiateViewControllerWithIdentifier:@"WorkoutModeViewController"];
        [wmvc setExercise:e];
        [self addChildViewController:wmvc];
    }
    [self.pageControl setCurrentPage:0];
    [self setPage:0];
    [self.pageControl setNumberOfPages:self.childViewControllers.count];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * self.childViewControllers.count, 
                                               self.scrollView.frame.size.height)];
    [self.view bringSubviewToFront:self.pageControl];
}

-(void) viewWillAppear:(BOOL)animated {
    
    for (NSInteger i = 0; i < [self.childViewControllers count]; i++) {
        [self loadScrollViewWithPage:i];
    }
    
    if (self.firstPage) {
        self.pageControl.currentPage = 0;
        self.page = 0;
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        
        [self.scrollView scrollRectToVisible:frame animated:YES];
        
        self.firstPage = NO;
    }
    CGRect nbframe = self.navigationController.navigationBar.frame;
    nbframe.size.width = 320;
    nbframe.size.height = 63;
    [self.navigationController.navigationBar setFrame:nbframe];
    
    CGRect tbframe = self.toolbar.frame;
    tbframe.size.width = 320;
    tbframe.size.height = 80;
    tbframe.origin.y = 336;
    [self.toolbar setFrame:tbframe];
    self.toolbar.backgroundColor = [UIColor clearColor];
    
    [self setToolbarBack:GB_BG_CHROME_BOTTOM toolbar:self.toolbar];
}

-(void)setToolbarBack:(NSString*)bgFilename toolbar:(UIToolbar*)toolbar {   
    // Add Custom Toolbar
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgFilename]];
    iv.frame = CGRectMake(0, 0, 320,80);
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // Add the tab bar controller's view to the window and display.
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 5)
        [toolbar insertSubview:iv atIndex:1]; // iOS5 atIndex:1
    else
        [toolbar insertSubview:iv atIndex:0]; // iOS4 atIndex:0
}

-(void) initialSetupOfFormWithWorkout:(Workout *)workout
{
    self.workout = workout;
    logbookEntries = [[NSMutableOrderedSet alloc]init];
    skippedEntries = [[NSMutableOrderedSet alloc]init];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UIViewController *old = [self.childViewControllers objectAtIndex:self.page];
    UIViewController *new = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [old viewDidDisappear:YES];
    [new viewDidAppear:YES];
    self.page = self.pageControl.currentPage;
}

-(void)loadScrollViewWithPage:(int)page {
    @try {
        if (page < 0)
            return;
        if (page >= [self.childViewControllers count])
            return;
        UIViewController *ctrl = [self.childViewControllers objectAtIndex:page];
        
        if (ctrl == nil)
            return;
        
        if (ctrl.view.superview == nil) {
            
            CGRect frame = self.scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            ctrl.view.frame = frame;
            [self.scrollView addSubview:ctrl.view];
        }
            
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    @try {
        if (self.pageControlUsed ||  self.rotating) {
            return;
        }
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth) +1;
        
        if (self.pageControl.currentPage != page) {
            UIViewController *old = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
            UIViewController *new = [self.childViewControllers objectAtIndex:page];
            [old viewWillDisappear:YES];
            [new viewWillAppear:YES];
            self.pageControl.currentPage = page;
            [old viewDidDisappear:YES];
            [new viewDidAppear:YES];
            self.page = page;
        }
    }
    @catch (NSException *exception) {

    }
    @finally {
        
    }
}

-(void) changePage:(id)sender {
    @try {
        int page = ((UIPageControl *)sender).currentPage;
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        
        UIViewController *old = [self.childViewControllers objectAtIndex:self.page];
        UIViewController *new = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
        [old viewWillDisappear:YES];
        [new viewWillAppear:YES];
        
        [self.scrollView scrollRectToVisible:frame animated:YES];
        self.pageControlUsed = YES;
        
    }
    @catch (NSException *exception) {

    }
    @finally {
        
    }
    
}

@end
