//
//  Workout.m
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "Workout.h"
#import "Exercise.h"


@implementation Workout

@dynamic deleted;
@dynamic workout_name;
@dynamic exercises;

- (void)addExercisesObject:(Exercise *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.exercises];
    [tempSet addObject:value];
    self.exercises = tempSet;
}

- (void)removeExercisesObject:(Exercise *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.exercises];
    [tempSet removeObject:value];
    self.exercises = tempSet;
}

@end
