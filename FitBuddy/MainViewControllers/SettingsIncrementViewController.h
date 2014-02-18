//
//  SettingsIncrementViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsIncrementViewController : UIViewController <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSUserDefaults *defaults;
@property  (nonatomic, strong) NSString *defaultsKey;
@property (nonatomic, weak) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerValues;
@property (nonatomic, weak) IBOutlet UILabel *spinnerTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *activityViewOverlay;

-(IBAction) confirmChange:(id) sender;

@end
