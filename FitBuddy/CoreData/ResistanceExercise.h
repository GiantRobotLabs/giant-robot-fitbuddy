//
//  ResistanceExercise.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"


@interface ResistanceExercise : Exercise

@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSString * weight;

@end
