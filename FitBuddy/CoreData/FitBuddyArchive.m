//
//  FitBuddyArchive.m
//  FitBuddy
//
//  Created by john.neyer on 2/8/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "FitBuddyArchive.h"
#import "GymBuddyAppDelegate.h"
#import "NSData+CocoaDevUsersAdditions.h"

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
    
    NSURL *dbUrl = [[documentsDirectory URLByAppendingPathComponent:@"Database"] URLByAppendingPathComponent:kDATABASE2_0];
    
    NSError *err;
    [[NSFileManager defaultManager] copyItemAtURL:dbUrl toURL:exportPath error:&err];
    
    if (err)
    {
        NSLog(@"Error exporting database: %@", err);
        return FALSE;
    }
    
    return TRUE;
}

- (NSData *)exportToNSData: (NSURL *) directoryUrl {
    NSError *error;

    NSFileWrapper *dirWrapper = [[NSFileWrapper alloc] initWithURL:directoryUrl options:0 error:&error];
    if (dirWrapper == nil) {
        NSLog(@"Error creating directory wrapper: %@", error.localizedDescription);
        return nil;
    }
    
    NSData *dirData = [dirWrapper serializedRepresentation];
    NSData *gzData = [dirData gzipDeflate];
    return gzData;
}

- (NSString *) getTimestamp
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyHHmmss"];
    
    NSString *timestamp = [format stringFromDate:[[NSDate alloc] init]];
    return timestamp;
}

@end
