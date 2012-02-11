//
//  Exercise.h
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSOrderedSet *workouts;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)insertObject:(Workout *)value inWorkoutsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWorkoutsAtIndex:(NSUInteger)idx;
- (void)insertWorkouts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWorkoutsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWorkoutsAtIndex:(NSUInteger)idx withObject:(Workout *)value;
- (void)replaceWorkoutsAtIndexes:(NSIndexSet *)indexes withWorkouts:(NSArray *)values;
- (void)addWorkoutsObject:(Workout *)value;
- (void)removeWorkoutsObject:(Workout *)value;
- (void)addWorkouts:(NSOrderedSet *)values;
- (void)removeWorkouts:(NSOrderedSet *)values;
@end
