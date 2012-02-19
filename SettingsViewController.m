//
//  SettingsViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "GymBuddyMacros.h"

@implementation SettingsViewController

@synthesize defaults = _defaults;

-(void) loadTableFromDefaults
{
    UITableViewCell *cell;
    for (cell in [self.tableView visibleCells])
    {
        UILabel *cellLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *cellDetail = (UILabel *)[cell viewWithTag: 200];
        
        if ([self.defaults stringForKey:cellLabel.text] != nil)
        {
            cellDetail.text = [self.defaults stringForKey:cellLabel.text] ;
        }
        else if ([cellLabel.text hasSuffix:@"Increment"])
        {
            NSLog(@"%@", cellLabel.text);
            cellDetail.text = @"0.5";
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 0, 315, 25);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    [self.tableView deselectRowAtIndexPath: [self.tableView indexPathForSelectedRow] animated:YES];
    cell.backgroundColor = [UIColor clearColor];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setDefaultsKey:)]) {
        UILabel *label = (UILabel *)[((UITableViewCell *)sender) viewWithTag:100];
        [segue.destinationViewController performSelector:@selector(setDefaultsKey:) withObject:(label.text)];
    }
        
    
}

@end
