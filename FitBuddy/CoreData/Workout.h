//
//  Workout.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, LogbookEntry;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * display;
@property (nonatomic, retain) NSDate * last_workout;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSOrderedSet *exercises;
@property (nonatomic, retain) NSOrderedSet *logbookEntries;
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
- (void)insertObject:(LogbookEntry *)value inLogbookEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLogbookEntriesAtIndex:(NSUInteger)idx;
- (void)insertLogbookEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLogbookEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLogbookEntriesAtIndex:(NSUInteger)idx withObject:(LogbookEntry *)value;
- (void)replaceLogbookEntriesAtIndexes:(NSIndexSet *)indexes withLogbookEntries:(NSArray *)values;
- (void)addLogbookEntriesObject:(LogbookEntry *)value;
- (void)removeLogbookEntriesObject:(LogbookEntry *)value;
- (void)addLogbookEntries:(NSOrderedSet *)values;
- (void)removeLogbookEntries:(NSOrderedSet *)values;
@end
