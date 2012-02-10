//
//  CoreDataHelper.h
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^completion_block_t)(UIManagedDocument *database);
typedef void (^completion_block_f)(NSFetchedResultsController *fetchedResultsController);

@interface CoreDataHelper : NSObject

+ (void)openDatabase:(NSString *) name usingBlock:(completion_block_t)completionBlock;
+ (void)setupExerciseFetchedResultsController:(UIManagedDocument *) doc usingBlock: (completion_block_f)completionBlock;
+ (void)getWorkoutFetchedResultsController:(UIManagedDocument *) doc usingBlock: (completion_block_f)completionBlock;

@end
