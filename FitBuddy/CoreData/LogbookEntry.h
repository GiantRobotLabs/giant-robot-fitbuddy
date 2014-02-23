//
//  LogbookEntry.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface LogbookEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * date_t;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * exercise_name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * pace;
@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) Workout *workout;

@end
