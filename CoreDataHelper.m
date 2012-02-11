//
//  CoreDataHelper.m
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "CoreDataHelper.h"
#import <CoreData/CoreData.h>

static NSMutableDictionary *managedDocumentDictionary;

@implementation CoreDataHelper

+ (void)openDatabase:(NSString *)name usingBlock:(completion_block_t)completionBlock
{
    // Try to retrieve the relevant UIManagedDocument from managedDocumentDictionary
    UIManagedDocument *document = [managedDocumentDictionary objectForKey:name];
    
    // Get URL for the database -> "<Documents Directory>/<database name>" 
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:name];
    
    // If UIManagedObject was not retrieved, create it
    if (!document) {
        
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


+(void) setupExerciseFetchedResultsController: (UIManagedDocument *) document usingBlock:(completion_block_f)completionBlock
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    completionBlock ([[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil]);  
}

+(void) getWorkoutFetchedResultsController: (UIManagedDocument *) document usingBlock:(completion_block_f)completionBlock
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    completionBlock ([[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                               managedObjectContext:document.managedObjectContext 
                                                 sectionNameKeyPath:nil 
                                                          cacheName:nil]);  
}

@end
