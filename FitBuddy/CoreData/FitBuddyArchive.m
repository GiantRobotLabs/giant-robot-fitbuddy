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

- (NSString *)getExportFileName
{
    NSString *fileName = kEXPORTNAME;
    NSString *zippedName = [fileName stringByAppendingString:kEXPORTEXT];
    return zippedName;
}

- (BOOL)exportToDiskWithForce:(BOOL)force {
    
    
    [self buildItems];
    // Figure out destination name (in public docs dir)    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *zippedName = [self getExportFileName];
    NSString *zippedPath = [documentsDirectory stringByAppendingPathComponent:zippedName];
    
    // Check if file already exists (unless we force the write)
    if (!force && [[NSFileManager defaultManager] fileExistsAtPath:zippedPath]) {
        return FALSE;
    }
    
    // Export to data buffer
    NSData *gzData = [self exportToNSData];
    if (gzData == nil) return FALSE;
    
    // Write to disk
    [gzData writeToFile:zippedPath atomically:YES];
    return TRUE;
    
}

- (NSData *)exportToNSData {
    NSError *error;
    NSURL *url = [GymBuddyAppDelegate sharedAppDelegate].applicationDocumentsDirectory;
    NSFileWrapper *dirWrapper = [[NSFileWrapper alloc] initWithURL:url options:0 error:&error];
    if (dirWrapper == nil) {
        NSLog(@"Error creating directory wrapper: %@", error.localizedDescription);
        return nil;
    }
    
    NSData *dirData = [dirWrapper serializedRepresentation];
    NSData *gzData = [dirData gzipDeflate];
    return gzData;
}

- (void) buildItems

{
    
    // Define the paths
    
    NSString *documentsPath = [NSHomeDirectory()
                               
                               stringByAppendingPathComponent:@"Documents"];
    
    NSString *testFolderPath = [documentsPath
                                
                                stringByAppendingPathComponent:@"TestFolder"];
    
    NSString *filePath1 = [testFolderPath
                           
                           stringByAppendingPathComponent:@"Hello.txt"];
    
    NSString *filePath2 = [documentsPath
                           
                           stringByAppendingPathComponent:@"Hello.txt"];
    
    
    
    NSError *error;
    
    BOOL success;
    
    
    
    // Create a folder
    
    if (![[NSFileManager defaultManager]
          
          fileExistsAtPath:testFolderPath])
        
    {
        
        success = [[NSFileManager defaultManager]
                   
                   createDirectoryAtPath:testFolderPath
                   
                   withIntermediateDirectories:NO
                   
                   attributes:nil error:&error];
        
        if (!success)
            
        {
            
            NSLog(@"Error creating test folder: %@",
                  
                  error.localizedFailureReason);
            
            return;
            
        }
        
    }
    
    
    
    // Now put a file there
    
    success = [@"Hello world\n" writeToFile:filePath1
               
                                 atomically:YES encoding:NSUTF8StringEncoding
               
                                      error:&error];
    
    if (!success)
        
    {
        
        NSLog(@"Error writing file 1: %@",
              
              error.localizedFailureReason);
        
        return;
        
    }
    
    
    
    // Put a file into the main Documents folder too
    
    success = [@"Hello world\n" writeToFile:filePath2
               
                                 atomically:YES encoding:NSUTF8StringEncoding
               
                                      error:&error];
    
    if (!success)
        
    {
        
        NSLog(@"Error writing file 2: %@",
              
              error.localizedFailureReason);
        
        return;
        
    }
    
    
    
    NSLog(@"Success. Files and folder created.");
    
}


@end
