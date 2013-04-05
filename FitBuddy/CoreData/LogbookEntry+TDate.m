//
//  LogbookEntry+TDate.m
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "LogbookEntry+TDate.h"

@implementation LogbookEntry (TDate)

-(NSDate *) getDate_t
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yyyy"];
    NSString *dateOnly = [format stringFromDate: self.date];

    return [format dateFromString:dateOnly]; 
}

@end
