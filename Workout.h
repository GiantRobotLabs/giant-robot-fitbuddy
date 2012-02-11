//
//  Workout.h
//  GymBuddy
//
//  Created by John Neyer on 2/10/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSOrderedSet *exercises;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)insertObject:(Exercise *)value inExercisesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExercisesAtIndex:(NSUInteger)idx;
- (void)insertExercises:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExercisesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExercisesAtIndex:(NSUInteger)idx withObject:(Exercise *)value;
- (void)replaceExercisesAtIndexes:(NSIndexSet *)indexes withExercises:(NSArray *)values;
- (void)addExercisesObject:(Exercise *)value;
- (void)removeExercisesObject:(Exercise *)value;
- (void)addExercises:(NSOrderedSet *)values;
- (void)removeExercises:(NSOrderedSet *)values;
@end
