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

@interface CoreDataHelper : NSObject

+ (void)openDatabase:(NSString *) name usingBlock:(completion_block_t)completionBlock;
+ (void)callSave: (NSManagedObjectContext *) obj;
+ (void)refetchDataFromFetchedResultsController: (NSFetchedResultsController *) frc;
+ (NSManagedObjectContext *) getActiveManagedObjectContext;

- (BOOL)importFromURL:(NSURL *)importURL;
+ (BOOL)checkiCloudExists;
+ (void)resetDatabaseConnection;
+ (BOOL) copyiCloudtoLocal;
+ (BOOL) copyLocaltoiCloud;

@end
