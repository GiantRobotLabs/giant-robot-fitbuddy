//
//  WorkoutSummaryViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutSummaryViewController.h"
#import "LogbookEntry.h"
#import "Workout.h"
#import "CoreDataHelper.h"
#import "GymBuddyAppDelegate.h"

@implementation WorkoutSummaryViewController
@synthesize navigationBar;

@synthesize finalProgress = _finalProgress;
@synthesize logbookEntries = _logbookEntries;
@synthesize skippedEntries = _skippedEntries;
@synthesize completedValue = _completedValue;
@synthesize numExercisesValue = _numExercisesValue;
@synthesize totalResistanceValue = _totalResistanceValue;
@synthesize totalDistanceValue = _totalDistanceValue;
@synthesize strengthLight = _strengthLight;
@synthesize cardioLight = _cardioLight;

NSFetchedResultsController *frc;

-(float) calculateWorkoutScore: (LogbookEntry *) entry
{
    float strengthScore = 0;
    
    if (entry.weight != nil)
    {
       strengthScore = [entry.weight floatValue] * [entry.reps floatValue] * [entry.sets floatValue];
    }
    
    return strengthScore;
}


-(float) calculateCardioScore: (LogbookEntry *) entry
{
    float cardioScore = 0;
    
    if (entry.distance != nil && [entry.distance floatValue] > 0)
    {
        cardioScore = [entry.distance floatValue];
    }
    else if (entry.pace != nil)
    {
        // dist = pace/hr * min/60.0
        cardioScore = [entry.pace floatValue] * [entry.duration floatValue] / 60.0;
    }
    
    return cardioScore;
}

-(LogbookEntry *)fetchOldLogbookEntry: (Workout *) workout
                                     priorToDate:(NSDate *) priorToDate
                                     exercise:(NSString *)exercise
{
    LogbookEntry *oldEntry = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(workout = %@) AND (exercise_name = %@) AND (date < %@) AND (completed = %@)", 
                         workout, exercise, priorToDate, [NSNumber numberWithBool:YES]];

    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                              managedObjectContext:[GymBuddyAppDelegate sharedAppDelegate].managedObjectContext
                                                sectionNameKeyPath:nil 
                                                         cacheName:nil];
    
    [frc performFetch:nil];
    NSArray *array = [frc fetchedObjects];
    
    if (array != nil && array.count > 0)
    {
        oldEntry = [array lastObject];
    }
    
    return oldEntry;
}

-(UIImage *) getTrafficLight: (float) score
{
    if (score < 0)
        return [UIImage imageNamed:GB_REDSTAT];
    if (score > 0)
        return [UIImage imageNamed:GB_GREENSTAT_PLUS];
    
    return [UIImage imageNamed:GB_GREENSTAT];
}

-(void) setLogbookScores
{
    LogbookEntry *entry;
    
    float distance = 0.0;
    float strength = 0.0;
    
    float distanceOld = 0.0;
    float strengthOld = 0.0;
    
    // Total Resistance = Sum of (Weight * Sets * Reps) for each complete logbook
    // Total Distance = Sum of (Pace * Time || Distance) for each complete logbook
    for (entry in [self.logbookEntries allValues])
    {
        if (entry && entry.completed)
        {
            LogbookEntry *oldLogbook = [self fetchOldLogbookEntry:entry.workout priorToDate:entry.date exercise:entry.exercise_name];
            
            strength += [self calculateWorkoutScore:entry];
            strengthOld += [self calculateWorkoutScore:oldLogbook];
            
            distance += [self calculateCardioScore:entry];
            distanceOld += [self calculateCardioScore:oldLogbook];            
        }
    }
    
    if (strengthOld != 0)
    {
        self.totalResistanceValue.text = [NSString stringWithFormat:@"%1.0f%%", (strength/strengthOld) * 100.0];
        self.strengthLight.image = [self getTrafficLight:(strength - strengthOld)];
    }
    else if (strength > 0)
    {
        self.totalResistanceValue.text = [NSString stringWithFormat:@"%1.0f%%", (1) * 100.0];
        self.strengthLight.image = [self getTrafficLight:(0)];
    }
    
    if (distanceOld != 0)
    {
        self.totalDistanceValue.text = [NSString stringWithFormat:@"%1.0f%%", (distance/distanceOld) * 100.0];
        self.cardioLight.image = [self getTrafficLight:(distance - distanceOld)];
    }
    else if (distance > 0)
    {
        self.totalDistanceValue.text = [NSString stringWithFormat:@"%1.0f%%", (1) * 100.0];
        self.cardioLight.image = [self getTrafficLight:(0)];   
    }
    
    NSLog(@"strength %f - strengthold %f", strength, strengthOld);
}

-(void) setForm
{
    self.completedValue.text = [NSString stringWithFormat:@"%1.0f%%", ([self.finalProgress floatValue] * 100)];
    self.numExercisesValue.text = [NSString stringWithFormat:@"%d", (self.logbookEntries.count - self.skippedEntries.count)];
    [self setLogbookScores];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Visual stuff
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    [self setForm];
;
}

-(void) viewDidAppear:(BOOL)animated

{
    
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setCompletedValue:nil];
    [self setNumExercisesValue:nil];
    [self setTotalResistanceValue:nil];
    [self setTotalDistanceValue:nil];
    [self setStrengthLight:nil];
    [self setCardioLight:nil];
    [super viewDidUnload];
}
@end
