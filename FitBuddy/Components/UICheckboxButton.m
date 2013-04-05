//
//  CheckboxLabel.m
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "UICheckboxButton.h"

@implementation UICheckboxButton

@synthesize checked = _checked;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.checked = !self.checked;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckboxToggled" object:self];
}

-(void) setChecked:(BOOL)checked
{
    [self setImageForValue:checked];
    _checked = checked;
}

-(void) setImageForValue: (BOOL) checked
{
    if (checked)
    {
        [self setImage: [UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage: [UIImage imageNamed:UNCHECKED_IMAGE] forState:UIControlStateNormal];
    }
}

@end
