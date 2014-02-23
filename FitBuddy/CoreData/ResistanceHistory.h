//
//  ResistanceHistory.h
//  FitBuddy
//
//  Created by john.neyer on 2/17/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ResistanceHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * comp;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * score;

@end
