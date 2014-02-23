//
//  SwitchCell.h
//  FitBuddy
//
//  Created by john.neyer on 1/26/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

@protocol SwitchCellDelegate;
@interface SwitchCell : UITableViewCell

- (IBAction)switched:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UISwitch *checkbox;

@end

@protocol SwitchCellDelegate

- (void)switchCell:(SwitchCell *)cell didSwitch:(BOOL)switchState;

@end