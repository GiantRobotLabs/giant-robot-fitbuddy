//
//  CoreDataHelper.h
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject
+ (BOOL) copyiCloudtoLocal;
+ (BOOL) migrateDataToSqlite;
+ (void)removeFilesUsingExpression:(NSRegularExpression*)regex inPath:(NSString*)path;
+ (BOOL) exportDatabaseTo: (NSString *) exportType;

@end