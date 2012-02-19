//
//  CardioExercise.h
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"


@interface CardioExercise : Exercise

@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * pace;

@end
