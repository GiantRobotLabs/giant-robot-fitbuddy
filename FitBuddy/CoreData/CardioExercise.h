//
//  CardioExercise.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"


@interface CardioExercise : Exercise

@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * pace;

@end
