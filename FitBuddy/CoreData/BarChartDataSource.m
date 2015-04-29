//
//  BarChartDataSource.m
//  FitBuddy
//
//  Created by john.neyer on 2/13/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "BarChartDataSource.h"
#import "FitBuddyMacros.h"
#import <CoreData/CoreData.h>

#import "FitBuddy-Swift.h"

@implementation BarChartDataSource

- (NSMutableDictionary *)cardioDataSource
{
    if (_cardioDataSource == nil)
    {
        _cardioDataSource = [[NSMutableDictionary alloc] init];
    }
    return _cardioDataSource;
}

-(NSMutableDictionary *)resistanceDataSource
{
    if (_resistanceDataSource == nil)
    {
        _resistanceDataSource = [[NSMutableDictionary alloc] init];
    }
    return _resistanceDataSource;
    
}

- (BOOL)load
{
    return [self buildHistoryArrays];
}

- (NSNumber *) numberOfRowsInResistanceLogbook
{
    return [NSNumber numberWithInteger:[self.resistanceDataSource count]];
}

- (NSNumber *) numberOfRowsInCardioLogbook
{
    return [NSNumber numberWithInteger:[self.cardioDataSource count]];
}

- (NSNumber *) numberOfRowsInResistanceHistory
{
    return [NSNumber numberWithInt:10];
}

- (NSNumber *) numberOfRowsInCardioHistory
{
    return [NSNumber numberWithInt:10];
}


#pragma mark - Loading options
- (BOOL) buildHistoryArrays
{
    if (DEBUG) NSLog(@"Clear chart history");
    [self clearTable: RESISTANCE_HISTORY];
    [self clearTable:CARDIO_HISTORY];
    
    if (DEBUG) NSLog(@"Rebuild history");
    NSFetchRequest *request = [[[AppDelegate sharedAppDelegate].managedObjectModel fetchRequestTemplateForName:RESISTANCE_LOGBOOK ] copy];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[AppDelegate sharedAppDelegate] managedObjectContext]sectionNameKeyPath:@"date_t" cacheName:nil];
    
    NSError *error;
    [frc performFetch:&error];
    
    if (!error)
    {
        NSArray *entries = frc.fetchedObjects;
        [self buildResistanceArray:entries];
        
    }
    
    
    request = [[[AppDelegate sharedAppDelegate].managedObjectModel fetchRequestTemplateForName:CARDIO_LOGBOOK] copy];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[AppDelegate sharedAppDelegate] managedObjectContext]sectionNameKeyPath:@"date_t" cacheName:nil];
    
    error = nil;
    [frc performFetch:&error];
    
    if (!error)
    {
        NSArray *entries = frc.fetchedObjects;
        [self buildCardioArray:entries];
    }
    
    
    return TRUE;
    
    
}

-(void) buildResistanceArray:(NSArray *) entries
{
    ResistanceHistory *currentObject = (ResistanceHistory *)[NSEntityDescription insertNewObjectForEntityForName:RESISTANCE_HISTORY inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
    
    for (id object in entries)
    {
        LogbookEntry *entry = (LogbookEntry *) object;

        double score = [currentObject.score doubleValue] + ([entry.weight doubleValue] * [entry.reps intValue] * [entry.sets intValue]);
        double compare = [currentObject.score doubleValue] - [[[self.resistanceDataSource objectForKey:currentObject.date]  valueForKey:@"score"] doubleValue];
                NSNumber *nscore = [[NSNumber alloc] initWithDouble:score];
        NSDate *entryDate = (NSDate *)[entry valueForKey:@"date_t"];
        NSNumber *ncomp = [[NSNumber alloc] initWithDouble:compare];
        
        currentObject.date = entryDate;
        currentObject.score = nscore;
        currentObject.comp = ncomp;
        
        [self.resistanceDataSource setObject:currentObject forKey:currentObject.date];
        
        if ([self.resistanceDataSource objectForKey: currentObject.date] == nil)
        {
            NSLog(@"Adding new resistance history for: %@ %f", entryDate , score);
            
            currentObject = (ResistanceHistory *)[NSEntityDescription insertNewObjectForEntityForName:RESISTANCE_HISTORY inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
            
        }
        
    }
}

-(void) buildCardioArray:(NSArray *) entries
{
    CardioHistory *currentObject = (CardioHistory *)[NSEntityDescription insertNewObjectForEntityForName:CARDIO_HISTORY inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
    
    for (id object in entries)
    {
        LogbookEntry *entry = (LogbookEntry *) object;
        
        double score = [currentObject.score doubleValue] + [entry.distance doubleValue];
        double compare = [currentObject.score doubleValue] - [[[self.cardioDataSource objectForKey:currentObject.date]  valueForKey:@"score"] doubleValue];
        
        NSNumber *nscore = [[NSNumber alloc] initWithDouble:score];
        NSDate *entryDate = (NSDate *)[entry valueForKey:@"date_t"];
        NSNumber *ncomp = [[NSNumber alloc] initWithDouble:compare];
        
        currentObject.date = entryDate;
        currentObject.score = nscore;
        currentObject.comp = ncomp;
        
        if ([self.cardioDataSource objectForKey: currentObject.date] == nil)
        {
            [self.cardioDataSource setObject:currentObject forKey:currentObject.date];
            NSLog(@"Adding cardio history for: %@ %f", entryDate , score);
            
            currentObject = (CardioHistory *)[NSEntityDescription insertNewObjectForEntityForName:CARDIO_HISTORY inManagedObjectContext:[AppDelegate sharedAppDelegate].managedObjectContext];
            
        }
        
    }
}

- (void) clearTable: (NSString *)table
{
    NSManagedObjectContext *context = [[AppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest * allRecs = [[NSFetchRequest alloc] init];
    [allRecs setEntity:[NSEntityDescription entityForName:table inManagedObjectContext:context]];
    [allRecs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * recs = [context executeFetchRequest:allRecs error:&error];

    //error handling goes here
    for (NSManagedObject * car in recs) {
        [context deleteObject:car];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    //more error handling here
 
}

#pragma mark = JBBarChartViewDataSource delegate
- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return 30;
}

- (NSInteger) numberOfSetItems
{
    return 30;
}


- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 1;
}

- (UIView *)barViewForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? kCOLOR_LTGRAY : kCOLOR_GRAY_t;
    return barView;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    
    double interval = -1 * ([self numberOfSetItems] - index - 1);
    NSDate *indexDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*interval];
    
    NSDateFormatter *dateOnlyFormat = [[NSDateFormatter alloc] init];
    [dateOnlyFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateOnly = [dateOnlyFormat stringFromDate: indexDate];
    
    
    ResistanceHistory *rec = [self.resistanceDataSource objectForKey:[dateOnlyFormat dateFromString:dateOnly]];
    
    NSNumber *score = rec.score;

    score = [NSNumber numberWithDouble: ([score doubleValue]/10000.0)];
    
    return [score doubleValue];
}

@end
