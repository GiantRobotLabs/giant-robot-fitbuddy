//
//  SettingsViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "FitBuddyMacros.h"

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
        else if ([cellLabel.text hasSuffix:@"Resistance Increment"])
        {
            cellDetail.text = @"2.5";
        }
        else if ([cellLabel.text hasSuffix:@"Cardio Increment"])
        {
            cellDetail.text = @"0.5";
        }
        else if ([cellLabel.text hasSuffix:@"Use iCloud"])
        {
            cellDetail.text = @"No";
        }
    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self loadTableFromDefaults];
}

-(void) viewDidLoad {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SEL setDefaultsKeySelector = sel_registerName("setDefaultsKey:");
    SEL setPickerValuesSelector = sel_registerName("setPickerValues:");
    
    NSInvocation *setDefaultsKey = [NSInvocation invocationWithMethodSignature:[[segue.destinationViewController class] instanceMethodSignatureForSelector:setDefaultsKeySelector]];
    setDefaultsKey.target = segue.destinationViewController;
    setDefaultsKey.selector = setDefaultsKeySelector;
    
    if ([segue.destinationViewController respondsToSelector:setDefaultsKeySelector])
    {
        
        UILabel *label = (UILabel *)[((UITableViewCell *)sender) viewWithTag:100];
        NSString *obj = label.text;
        [setDefaultsKey setArgument:&obj atIndex:2];
        [setDefaultsKey invoke];
        
        NSMutableArray *pickerValues = [[NSMutableArray alloc]init];
        UILabel *defaultLabel = (UILabel *)[((UITableViewCell *)sender) viewWithTag:200];
        
        if ([label.text hasSuffix:@"Cardio Increment"]) {
            [pickerValues addObjectsFromArray:@[@"0.5", @"1.0", @"2.0", @"2.5", @"5.0"]];
        }
        
        if([label.text hasSuffix:@"Resistance Increment"]) {
            [pickerValues addObjectsFromArray:@[@"0.5", @"1.0", @"2.0", @"2.5", @"5.0"]];
        }
        
        if ([label.text hasSuffix:@"Use iCloud"]) {
            [pickerValues addObjectsFromArray:@[@"Yes", @"No"]];
        }
        
        if ([label.text hasSuffix:@"Export Database"]) {
            [pickerValues addObjectsFromArray:@[@"iTunes"]];
        }
        
        NSInvocation *setPicker = [NSInvocation invocationWithMethodSignature:[[segue.destinationViewController class] instanceMethodSignatureForSelector:setPickerValuesSelector]];
        setPicker.target = segue.destinationViewController;
        setPicker.selector = setPickerValuesSelector;
        
        [self addPickerValue:pickerValues value: defaultLabel.text];
        [setPicker setArgument:&pickerValues atIndex:2];
        [setPicker invoke];
    }
}

- (NSArray *) addPickerValue:(NSMutableArray *)array value:(NSString *) value
{
    if (![array containsObject:value]){
        [array addObject:value];
    }
    
    [array sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
    
    return array;
}

@end