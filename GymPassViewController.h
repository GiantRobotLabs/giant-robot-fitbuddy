//
//  GymPassViewController.h
//  FitBuddy
//
//  Created by john.neyer on 3/7/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface GymPassViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *memberNameField;
@property (weak, nonatomic) IBOutlet UITextField *memberNumberField;
@property (weak, nonatomic) IBOutlet UITableView *locationTable;
@property (weak, nonatomic) IBOutlet UIButton *makeAPassButton;
@property (weak, nonatomic) IBOutlet UITextField *locationNameField;

@property (strong, nonatomic) FSVenue *venue;

- (IBAction)makePassButtonClicked:(id)sender;
- (IBAction)textFieldEditingDidEnd:(id)sender;

- (void) showPass: (BOOL) animated;

@end
