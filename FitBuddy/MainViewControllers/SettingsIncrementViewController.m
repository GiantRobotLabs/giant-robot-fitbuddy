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

@implementation SettingsIncrementViewController
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
        
        if ([self.defaultsKey isEqualToString:kUSEICLOUDKEY])
        {
            [self handleiCloudToggle:value];
        }
        else
        {
            [self exit];
        }
    }
    else
    {
        [self exit];
    }
}


#pragma mark - iCloud Handler
- (void) handleiCloudToggle: (NSString *) value
{
    if ([value isEqualToString:kYES])
    {
        if ([[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Can't activate iCloud"
                                  message: @"It doesn't look like iCloud is enabled on this device. Please go to the Settings app to make sure your iCloud account is set up and active."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            [self.defaults setObject:@"No" forKey:self.defaultsKey];
            [self loadPickerFromDefaults];
            
        }
        else if ([self iCloudExists])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Switching to iCloud"
                                  message: @"It looks like there is already FitBuddy data in iCloud. Would you like to recover or replace the iCloud workout data."
                                  delegate: self
                                  cancelButtonTitle:@"Recover"
                                  otherButtonTitles:@"Replace", nil];
            [alert show];
        }
        else
        {
            [self migrateLocalToiCloud];
        }
    }
    else if ([value isEqualToString:kNO])
    {
        [self migrateiCloudToLocal];
    }
}

-(void)alertView:(UIAlertView *)alert_view didDismissWithButtonIndex:(NSInteger)button_index
{
    if (button_index == 0)
    {
        NSLog (@"Recover");
        // Nothing to do here
        [self exit];
    }
    else if (button_index == 1)
    {
        NSLog(@"Replace");
        
        [self migrateLocalToiCloud];
        [self exit];
    }
}

-(BOOL) migrateLocalToiCloud
{
    //TODO: do it
    return TRUE;
}

-(BOOL) migrateiCloudToLocal
{
    //TODO: do it
    return TRUE;
}

-(BOOL) iCloudExists
{
    //TODO: determine if icloud exists
    return TRUE;
}

#pragma mark - Export Options
- (void) handleExportToggle: (NSString *) exportType
{
    [CoreDataHelper exportDatabaseTo:exportType];
}


#pragma mark - Exit
- (void) exit
{
    [self.defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
