//
//  SettingsIncrementViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SettingsIncrementViewController.h"
#import "GymBuddyMacros.h"

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
    [self.defaults setObject:label.text forKey:self.defaultsKey];  
    [self loadTableFromDefaults];
}




@end
