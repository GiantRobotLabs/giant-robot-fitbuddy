//
//  ExerciseLog.h
//  GymBuddy
//
//  Created by John Neyer on 2/7/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExerciseLog : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * log_id;
@property (nonatomic, retain) NSNumber * workout_id;
@property (nonatomic, retain) NSNumber * exercise_id;

@end
