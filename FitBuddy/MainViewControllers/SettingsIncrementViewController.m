//
//  SettingsIncrementViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SettingsIncrementViewController.h"
#import "CoreDataHelper.h"
#import "FitBuddyMacros.h"
#import <QuartzCore/QuartzCore.h>

#import "FitBuddy-Swift.h"

@implementation SettingsIncrementViewController
{
    UIActivityIndicatorView* activityIndicatorView;
}

@synthesize defaults = _defaults;
@synthesize defaultsKey = _key;

-(void) setDefaultsKey:(NSString *)defaultsKey
{
    _key = defaultsKey;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerValues count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerValues[row];
    
}

-(void) loadPickerFromDefaults
{
    NSString *value = [self.defaults stringForKey:self.defaultsKey];
    if (value)
    {
        NSInteger index = [self.pickerValues indexOfObject:value];
        [self.picker selectRow:index inComponent:0 animated:YES];
    }
    else
    {
        [self.picker selectRow:0 inComponent:0 animated:YES];
    }
    
    [self.picker reloadComponent:0];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self loadPickerFromDefaults];
    [self.spinnerTitle setText:self.defaultsKey];
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
}


-(void) confirmChange:(id)sender {
    
    NSInteger index = [self.picker selectedRowInComponent:0];
    NSString *value = self.pickerValues[index];
    
    if ([self.defaultsKey isEqualToString:kEXPORTDBKEY])
    {
        [self handleExportToggle: value];
        [self exit];
    }
    
    
    if (![[self.defaults objectForKey:self.defaultsKey] isEqualToString: value])
    {
        [self.defaults setObject:value forKey:self.defaultsKey];
        
    }
    else
    {
        [self exit];
    }
}

#pragma mark - Export Options
- (void) handleExportToggle: (NSString *) exportType
{
    [CoreDataHelper exportDatabaseTo:exportType];
}

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    activityIndicatorView.backgroundColor = kCOLOR_GRAY_t;
    activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}

#pragma mark - Exit
- (void) exit
{
    [self.defaults synchronize];
    [[AppDelegate sharedAppDelegate] syncSharedDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
