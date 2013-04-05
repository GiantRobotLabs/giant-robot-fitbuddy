//
//  SettingsIncrementViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SettingsIncrementViewController.h"
#import "GymBuddyMacros.h"
#import "CoreDataHelper.h"

@implementation SettingsIncrementViewController

@synthesize defaults = _defaults;
@synthesize defaultsKey = _key;

-(void) setDefaultsKey:(NSString *)defaultsKey
{
    _key = defaultsKey;
     self.navigationItem.title = self.defaultsKey;
}

-(void) loadTableFromDefaults
{
    UITableViewCell *cell;
    NSString *value = [self.defaults stringForKey:self.defaultsKey];

    for (cell in [self.tableView visibleCells])
    {
        UILabel *cellLabel = (UILabel *)[cell viewWithTag:100];
        
        if ([value isEqualToString:cellLabel.text])
        {
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GB_CHECK_WHITE]];
            cell.accessoryView = checkmark;
        }
        else
        {
            cell.accessoryView = nil;
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Visual stuff    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    [self loadTableFromDefaults];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:100];
    
    if (![[self.defaults objectForKey:self.defaultsKey] isEqualToString: label.text])
    {
        [self.defaults setObject:label.text forKey:self.defaultsKey];
        
        if ([self.defaultsKey isEqualToString:@"Use iCloud"])
        {
            [CoreDataHelper resetDatabaseConnection];
            [self handleiCloudToggle:label.text];
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

- (void) handleiCloudToggle: (NSString *) value
{ 
    if ([value isEqualToString:@"Yes"])
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
            
        }
        else if ([CoreDataHelper checkiCloudExists])
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
            if ([CoreDataHelper copyLocaltoiCloud] == YES)
            {
                [self exit];  
            }
        }
    }
    else if ([value isEqualToString:@"No"])
    {
        //Copy iCloud to local database
        if ([CoreDataHelper copyiCloudtoLocal] == YES)
        {
            [self exit];   
        }
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
        // Copy local database to iCloud
        if ([CoreDataHelper copyLocaltoiCloud] == YES)
        {
            [self exit]; 
        }
    }
}

- (void) exit
{
    [self loadTableFromDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
