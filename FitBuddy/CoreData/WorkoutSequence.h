//
//  WorkoutSequence.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Workout;

@interface WorkoutSequence : NSManagedObject

@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) Workout *workout;

@end
