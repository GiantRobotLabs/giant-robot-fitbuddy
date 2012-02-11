//
//  CheckboxLabel.m
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "UICheckboxButton.h"
#import "Exercise.h"
#import "Workout.h"

@implementation UICheckboxButton

@synthesize checked = _checked;
@synthesize exerciseObject = _exerciseObject;
@synthesize workoutObject = _workoutObject;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.checked = !self.checked;
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
        [self setImage: [UIImage imageNamed:@"sm-checked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage: [UIImage imageNamed:@"sm-unchecked.png"] forState:UIControlStateNormal];
    }
}

@end
