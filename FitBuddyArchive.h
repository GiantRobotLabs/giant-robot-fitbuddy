//
//  FitBuddyArchive.h
//  FitBuddy
//
//  Created by john.neyer on 2/8/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitBuddyArchive : NSObject

- (NSString *)getExportFileName;
- (BOOL)exportToDiskWithForce:(BOOL)force;

@end
