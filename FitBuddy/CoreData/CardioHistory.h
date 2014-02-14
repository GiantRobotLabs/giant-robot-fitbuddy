//
//  CardioHistory.h
//  FitBuddy
//
//  Created by john.neyer on 2/13/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CardioHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * comp;

@end
