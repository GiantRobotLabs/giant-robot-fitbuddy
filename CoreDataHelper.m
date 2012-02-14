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

static NSMutableDictionary *managedDocumentDictionary = nil;

@implementation CoreDataHelper

+ (void)openDatabase:(NSString *)name usingBlock:(completion_block_t)completionBlock
{
    if (DEBUG) NSLog(@"Entering open database block");
    
    if (managedDocumentDictionary == nil)
        managedDocumentDictionary = [[NSMutableDictionary alloc]init];
    
    // Try to retrieve the relevant UIManagedDocument from managedDocumentDictionary
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:name];
    
    // Get URL for the database -> "<Documents Directory>/<database name>" 
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:name];
    
    // If UIManagedObject was not retrieved, create it
    if (!document) {
        
        if (DEBUG) NSLog(@"Database [%@] not found. Fetching a new database managed object", name);
        // Create UIManagedDocument with this URL
        document = [[UIManagedDocument alloc] initWithFileURL:url];

        // Migrate Models
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
       document.persistentStoreOptions = options;

        // Add to managedDocumentDictionary
        [managedDocumentDictionary setObject:document forKey:name];
    }
    
    // If document exists on disk...
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) 
    {
        [document openWithCompletionHandler:^(BOOL success) 
         {
             completionBlock(document);
         }];
    } 
    else 
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) { }];
    }
}

+ (NSManagedObjectContext *) getActiveManagedObjectContext
{
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:DATABASE];
    
    if (document)
        return document.managedObjectContext;
    else
        return nil;
}

+ (void) callSave: (NSManagedObjectContext *) obj
{
    NSError *err = nil;
    
    [obj save:&err];
    
    if (!err)
    {
         if (DEBUG) NSLog(@"Save successful");
    }
    else
    {
        if (DEBUG) NSLog(@"Save failed: %@", err);
    }
}

+ (void) refetchDataFromFetchedResultsController:(NSFetchedResultsController *)frc
{
    NSError *err = nil;
    
    [frc performFetch:&err];
    
    if (!err)
    {
        if (DEBUG) NSLog(@"Fetch successful");
    }
    else
    {
        if (DEBUG) NSLog(@"Fetch failed: %@", err);
    }
}

@end
