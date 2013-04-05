//
//  ResistanceExercise.h
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"


@interface ResistanceExercise : Exercise

@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSString * reps;

@end
