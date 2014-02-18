//
//  Exercise.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * sequence;
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
