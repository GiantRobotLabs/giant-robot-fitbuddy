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
            [self migrateLocalToiCloudWithRecovery:YES];
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
        [self migrateLocalToiCloudWithRecovery:YES];
    }
    else if (button_index == 1)
    {
        NSLog(@"Replace");
        
        [self migrateLocalToiCloudWithRecovery:NO];
    }
}

-(BOOL) migrateLocalToiCloudWithRecovery: (BOOL) recover
{
    
    NSError *err;
    NSDictionary *options = [CoreDataHelper defaultStoreOptionsForCloud:YES];
    
    [self waitForiCloudResponse];
    
    NSPersistentStore *oldstore = [[AppDelegate sharedAppDelegate]. persistentStoreCoordinator.persistentStores lastObject];
    
    if (recover)
    {
        NSPersistentStore *newStore = [[AppDelegate sharedAppDelegate].persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options error:&err];
        
        [[[AppDelegate sharedAppDelegate] persistentStoreCoordinator] removePersistentStore:oldstore error:&err];
        
        if (err)
        {
            NSLog(@"Failed to replace Cloud store with Local store: %@", err);
            
            return FALSE;
        }
    }
    else
    {
        [[AppDelegate sharedAppDelegate].persistentStoreCoordinator migratePersistentStore:oldstore toURL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options withType:NSSQLiteStoreType error:&err];
        
        if (err)
        {
            NSLog(@"Failed to migrate Local to iCloud store: %@", err);
            return FALSE;
        }
    }
    
    return TRUE;
}

-(BOOL) migrateiCloudToLocal
{
    NSError *err;
    NSDictionary *options = [CoreDataHelper defaultStoreOptionsForCloud:NO];
    
    [self waitForiCloudResponse];
    
    NSPersistentStore *oldstore = [[AppDelegate sharedAppDelegate]. persistentStoreCoordinator.persistentStores lastObject];
    
    [CoreDataHelper moveLocalStoreToBackup];
    
    NSPersistentStoreCoordinator *psc = [AppDelegate sharedAppDelegate].persistentStoreCoordinator;
    
   NSPersistentStore *newStore = [[AppDelegate sharedAppDelegate].persistentStoreCoordinator migratePersistentStore:oldstore toURL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options withType:NSSQLiteStoreType error:&err];
    
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options error:&err];
    
    if (err)
    {
        NSLog(@"Failed to migrate iCloud to local store: %@", err);
        return FALSE;
    }
    
    [self exit];
    return TRUE;
}

-(BOOL) iCloudExists
{
    //TODO: determine if icloud exists
   
    return FALSE;
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

- (void) waitForiCloudResponse
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDidRespond:) name:kUBIQUITYCHANGED object:[AppDelegate sharedAppDelegate].coreDataConnection];
    [self showActivityIndicatorOnView:self.tabBarController.view.superview];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:FALSE];
}

- (void) cloudDidRespond: (id) sender
{
    NSLog(@"response from icloud");
    
    [activityIndicatorView stopAnimating];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:TRUE];
    activityIndicatorView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self exit];
}

#pragma mark - Exit
- (void) exit
{
    [self.defaults synchronize];
    [[AppDelegate sharedAppDelegate] syncSharedDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
