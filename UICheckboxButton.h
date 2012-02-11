//
//  CheckboxLabel.h
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"
#import "Workout.h"

@interface UICheckboxButton : UIButton

@property (nonatomic) BOOL checked;
@property (nonatomic, weak) Exercise *exerciseObject;
@property (nonatomic, weak) Workout *workoutObject;

-(void) setImageForValue: (BOOL) checked;

@end
