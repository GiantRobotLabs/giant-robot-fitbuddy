//
//  CoreDataHelper.m
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "CoreDataHelper.h"
#import "GymBuddyAppDelegate.h"
#import "FitBuddyArchive.h"

@implementation CoreDataHelper

+ (BOOL) copyiCloudtoLocal
{
    BOOL rtn = NO;
    
    NSURL *iCloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *appDocsUrl = [[GymBuddyAppDelegate sharedAppDelegate] applicationDocumentsDirectory];
    
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtURL:[appDocsUrl URLByAppendingPathComponent:kDATABASE1_0] error:&err];
    [[NSFileManager defaultManager] copyItemAtURL:[iCloudUrl URLByAppendingPathComponent:kDATABASE1_0] toURL:[appDocsUrl URLByAppendingPathComponent:kDATABASE1_0] error:&err];
    
    if (DEBUG) NSLog(@"Tried to copy db: %@", err);
    
    if (err == nil)
        rtn = YES;
    
    return rtn;
}

#define TEMPFILENAME @"fitbuddy.tmp"
#define BACKUPFILENAME @"fitbuddy.bak"

+ (BOOL) migrateDataToSqlite
{
    
    NSError *err;
    NSURL *appDocsUrl = [[GymBuddyAppDelegate sharedAppDelegate] applicationDocumentsDirectory];
    
    NSURL *oldDbStorePath = [appDocsUrl URLByAppendingPathComponent:kDATABASE1_0];
    NSURL *oldSqlFilePath = [oldDbStorePath URLByAppendingPathComponent:@"/StoreContent/persistentStore"];
    NSURL *backupFileUrl = [appDocsUrl URLByAppendingPathComponent:TEMPFILENAME];
    NSURL *tempFileUrl = [appDocsUrl URLByAppendingPathComponent:TEMPFILENAME];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[oldDbStorePath path]]) {
        // We cleaned up already or this is a new install.
        // Nothing to migrate.
        return TRUE;
    }
    
    // Check if we're on iCloud and move to local
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kUSEICLOUDKEY] isEqualToString:kYES])
    {
        [CoreDataHelper copyiCloudtoLocal];
        [[NSUserDefaults standardUserDefaults] setObject:kNO forKey:kUSEICLOUDKEY];
        if (DEBUG) NSLog(@"Turning off iCloud prior to migration");
    }
    
    // Start migrating
     NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSPersistentStoreCoordinator *psc = [GymBuddyAppDelegate sharedAppDelegate].persistentStoreCoordinator;
    NSPersistentStore *oldStore = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:oldSqlFilePath options:options error:&err];
    
   if (oldStore)
   {
       [psc migratePersistentStore:oldStore toURL:tempFileUrl options:options withType:NSSQLiteStoreType error:&err];
   }
   
    NSURL *newFileUrl = [[appDocsUrl URLByAppendingPathComponent:@"Database"] URLByAppendingPathComponent:kDATABASE2_0];
    
    // Disconnect databases to prepare for the shuffle
    while ([psc.persistentStores lastObject]) {
        [psc removePersistentStore:[psc.persistentStores lastObject] error:&err];
    }
    
    [[NSFileManager defaultManager] replaceItemAtURL:newFileUrl withItemAtURL:backupFileUrl backupItemName:BACKUPFILENAME options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:&newFileUrl error:&err];
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:newFileUrl options:options error:&err];
    

    // If no errors - Clean up temp files
    if (!err)
    {
        if (DEBUG) NSLog(@"Migration complete.");
        
        NSString *temp = TEMPFILENAME;
        NSRegularExpression *re = [[NSRegularExpression alloc]initWithPattern:[temp stringByAppendingString: @"-.*"] options:NSRegularExpressionCaseInsensitive error:&err];
        
        [CoreDataHelper removeFilesUsingExpression:re inPath:[appDocsUrl path]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[oldDbStorePath path]])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[oldDbStorePath path] error:&err];
        }
        
        return TRUE;
    }
    else
    {
        NSLog(@"There was a problem migrating the database: %@", err);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[backupFileUrl path]])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[backupFileUrl path] error:&err];
        }
        
        if (err) {
            NSLog(@"Error removing temp file: %@", err);
        }
        
        return FALSE;
    }
}

+ (void)removeFilesUsingExpression:(NSRegularExpression*)regex inPath:(NSString*)path {
    NSDirectoryEnumerator *filesEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    NSString *file;
    NSError *error;
    while (file = [filesEnumerator nextObject]) {
        NSUInteger match = [regex numberOfMatchesInString:file
                                                  options:0
                                                    range:NSMakeRange(0, [file length])];
        if (match) {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
        }
    }
}

+ (BOOL) exportDatabaseTo: (NSString *) exportType
{
    if ([exportType isEqualToString:kITUNES])
    {
        FitBuddyArchive *arch = [[FitBuddyArchive alloc] init];
        return [arch exportToDiskWithForce:TRUE];
    }

    NSLog(@"Unknown export type: %@", exportType);
    return FALSE;

}

@end
