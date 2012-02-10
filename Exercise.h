//
//  Exercise.h
//  GymBuddy
//
//  Created by John Neyer on 2/9/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * exercise_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSString * weight;

@end
