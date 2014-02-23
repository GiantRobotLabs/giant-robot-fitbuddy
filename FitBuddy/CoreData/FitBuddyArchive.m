//
//  FitBuddyArchive.m
//  FitBuddy
//
//  Created by john.neyer on 2/8/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FitBuddyArchive.h"
#import "GymBuddyAppDelegate.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "CoreDataHelper.h"

@implementation FitBuddyArchive
{
    NSString *_fileName;
}

- (NSString *)getExportFileName
{
    if (_fileName)
    {
        return _fileName;
    }
    
    _fileName = [[[kEXPORTNAME stringByAppendingString:@"-"] stringByAppendingString:[self getTimestamp]] stringByAppendingString:kEXPORTEXT];
    return _fileName;
}

- (BOOL)exportToDiskWithForce:(BOOL)force {

    // Figure out destination name (in public docs dir)    
    NSURL *documentsDirectory = [GymBuddyAppDelegate sharedAppDelegate].applicationDocumentsDirectory;
    NSString *exportName = [self getExportFileName];
    NSURL *exportPath = [documentsDirectory URLByAppendingPathComponent:exportName];
    
    NSError *err;

    NSDictionary *options = [CoreDataHelper defaultStoreOptionsForCloud:NO];
    
    NSPersistentStoreCoordinator *psc = [[GymBuddyAppDelegate sharedAppDelegate] persistentStoreCoordinator];
    
    NSPersistentStore *ps = [[psc persistentStores] lastObject];
    
    [psc migratePersistentStore:ps toURL:exportPath options:options withType:NSSQLiteStoreType error:&err];
    
    if (err)
    {
        NSLog(@"Error exporting database: %@", err);
        return FALSE;
    }
    
    return TRUE;
}

- (NSString *) getTimestamp
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyHHmmss"];
    
    NSString *timestamp = [format stringFromDate:[[NSDate alloc] init]];
    return timestamp;
}

@end
