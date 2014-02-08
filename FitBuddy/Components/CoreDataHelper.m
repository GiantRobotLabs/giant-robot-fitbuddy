//
//  CoreDataHelper.m
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "CoreDataHelper.h"
#import <CoreData/CoreData.h>
#import "GymBuddyMacros.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "GymBuddyAppDelegate.h"

static NSMutableDictionary *managedDocumentDictionary = nil;
static UIManagedDocument *cdhDocument = nil;

@implementation CoreDataHelper


/*
+ (void)openDatabase:(NSString *)name usingBlock:(completion_block_t)completionBlock
{
    //if (DEBUG) NSLog(@"Entering open database block");
    
    if (managedDocumentDictionary == nil)
        managedDocumentDictionary = [[NSMutableDictionary alloc]init];
    
    // Try to retrieve the relevant UIManagedDocument from managedDocumentDictionary
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:name];
    
    // Get URL for the database -> "<Documents Directory>/<database name>" 
    // Set options with migration
    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSDictionary *fileOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];

    NSURL *iCloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSDictionary *iCloudOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             name, NSPersistentStoreUbiquitousContentNameKey,
                             [iCloudUrl URLByAppendingPathComponent:@"CoreData"], NSPersistentStoreUbiquitousContentURLKey,
                             nil];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *url = nil;
    NSDictionary *options = nil;
    
    NSString *value = [defaults valueForKey:@"Use iCloud"];
    if (value && [value isEqualToString:@"Yes"])
    {
        NSLog(@"opening icloud store");
    
        url = [iCloudUrl URLByAppendingPathComponent:name];
        options = iCloudOptions;
    }
    else
    {
        NSLog(@"opening file store");
        url = [fileUrl URLByAppendingPathComponent:name];
        options = fileOptions;
    }
    
    // If UIManagedObject was not retrieved, create it
    if (!document) {
        
        // Create UIManagedDocument with this URL
        document = [[UIManagedDocument alloc] initWithFileURL:url];
        document.persistentStoreOptions = options;

        // Add to managedDocumentDictionary
        [managedDocumentDictionary setObject:document forKey:name];
    }
    
    // If document exists on disk...
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) 
    {
        NSLog(@"File URL %@", url);
        [document openWithCompletionHandler:^(BOOL success) 
         {
             completionBlock(document);
         }];
    } 
    else 
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) { }];
    }
    
    cdhDocument = document;
}

+ (NSManagedObjectContext *) getActiveManagedObjectContext
{
    
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:DATABASE];
    
    NSManagedObjectContext *context = [[UIApplication sharedApplication].delegate performSelector:NSSelectorFromString(@"managedObjectContext")];
    
    if (document)
       return document.managedObjectContext;
    else
        return context;
}

+ (void) callSave: (NSManagedObjectContext *) obj
{
    NSError *err = nil;
    
    [obj save:&err];
    
    if (!err)
    {
         //if (DEBUG) NSLog(@"Save successful");
    }
    else
    {
        //if (DEBUG) NSLog(@"Save failed: %@", err);
    }
}

+ (void) refetchDataFromFetchedResultsController:(NSFetchedResultsController *)frc
{
    NSError *err = nil;
    
    [frc performFetch:&err];
    
    if (!err)
    {
        //if (DEBUG) NSLog(@"Fetch successful");
    }
    else
    {
        //if (DEBUG) NSLog(@"Fetch failed: %@", err);
    }
}
*/

+ (BOOL)checkiCloudExists
{
    NSURL *iCloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: [iCloudUrl URLByAppendingPathComponent:DATABASE].path])
        return YES;
    else
        return NO;
}

+ (void) resetDatabaseConnection
{
    NSError *err;
    [[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext save:&err];
    
    if (!err)
    {
        //if (DEBUG) NSLog(@"Save successful");
    }
    else
    {
        //if (DEBUG) NSLog(@"Save failed: %@", err);
    }
    
    managedDocumentDictionary = [[NSMutableDictionary alloc]init];
}
 
+ (BOOL) copyLocaltoiCloud
{
    BOOL rtn = NO;
    
    NSURL *iCloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtURL:[iCloudUrl URLByAppendingPathComponent:DATABASE] error:&err];
    [[NSFileManager defaultManager] copyItemAtURL:[fileUrl URLByAppendingPathComponent:DATABASE] toURL:[iCloudUrl URLByAppendingPathComponent:DATABASE] error:&err];
    
    NSLog(@"Tried to copy db: %@", err);
    
    if (err == nil)
        rtn = YES;
    return rtn;
}


+ (BOOL) copyiCloudtoLocal
{
    BOOL rtn = NO;
    
    NSURL *iCloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtURL:[fileUrl URLByAppendingPathComponent:DATABASE] error:&err];
    [[NSFileManager defaultManager] copyItemAtURL:[iCloudUrl URLByAppendingPathComponent:DATABASE] toURL:[fileUrl URLByAppendingPathComponent:DATABASE] error:&err];
    
    NSLog(@"Tried to copy db: %@", err);
    
    if (err == nil)
        rtn = YES;
    return rtn;
}

static UIManagedDocument *oldDatabase;

+ (BOOL) migrateDataToSqlite: (NSManagedObjectContext *) newContext {
    
    NSError *err;
    
    NSURL *fileUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Use iCloud"] isEqualToString:@"Yes"])
    {
        [CoreDataHelper copyiCloudtoLocal];
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Use iCloud"];
        NSLog(@"Turning off iCloud prior to migration");
    }
    
    //[CoreDataHelper openDatabase:DATABASE usingBlock:^(UIManagedDocument *doc) {
    //    oldDatabase = doc;
    //}];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: oldDatabase.managedObjectModel];
    NSPersistentStore *oldStore = [psc persistentStoreForURL:[fileUrl URLByAppendingPathComponent:DATABASE]];

    [psc migratePersistentStore:oldStore toURL: [fileUrl URLByAppendingPathComponent:@"fitbuddy.gbz"]  options:options withType:NSSQLiteStoreType error:&err];
    
    return TRUE;
}

- (BOOL)importData:(NSData *)zippedData {
    
    // Read data into a dir Wrapper
    NSData *unzippedData = [zippedData gzipInflate];
    NSFileWrapper *dirWrapper = [[NSFileWrapper alloc] initWithSerializedRepresentation:unzippedData];
    if (dirWrapper == nil) {
        NSLog(@"Error creating dir wrapper from unzipped data");
        return FALSE;
    }
    
    // Calculate desired name
    NSURL *dirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    dirUrl = [dirUrl URLByAppendingPathComponent:DATABASE];
    NSError *error;
    BOOL success = [dirWrapper writeToURL:dirUrl options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
    if (!success) {
        NSLog(@"Error importing file: %@", error.localizedDescription);
        return FALSE;
    }
    
    // Success!
    return TRUE;
}

- (BOOL)importFromURL:(NSURL *)importURL {
    NSData *zippedData = [NSData dataWithContentsOfURL:importURL];
    return [self importData:zippedData];
}


@end
