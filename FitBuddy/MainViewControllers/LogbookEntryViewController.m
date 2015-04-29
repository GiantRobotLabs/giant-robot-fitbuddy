//
//  LogbookEntryViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/19/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "LogbookEntryViewController.h"
#import "CoreDataHelper.h"
#import "FitBuddyMacros.h"

@implementation LogbookEntryViewController

@synthesize logbookEntry = _logbookEntry;
@synthesize entryDate = _entryDate;
@synthesize entryName = _entryName;
@synthesize slotOneLabel = _slotOneLabel;
@synthesize slotTwoLabel = _slotTwoLabel;
@synthesize slotThreeLabel = _slotThreeLabel;
@synthesize colOneDate = _colOneDate;
@synthesize colTwoDate = _colTwoDate;
@synthesize slotOneColOne = _slotOneColOne;
@synthesize slotTwoColOne = _slotTwoColOne;
@synthesize slotThreeColOne = _slotThreeColOne;
@synthesize slotOneColTwo = _slotOneColTwo;
@synthesize slotTwoColTwo = _slotTwoColTwo;
@synthesize slotThreeColTwo = _slotThreeColTwo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    
}

-(NSString *) tinyDateFormat: (NSDate *) date
                      format:(NSString *) format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

-(void) loadFormDataFromLogbook
{
    // Set the data
    self.entryDate.text = [self tinyDateFormat:self.logbookEntry.date format:@"dd MMM yyyy"];
    
    self.entryName.text = self.logbookEntry.exercise_name;
    
    if (self.logbookEntry.pace || self.logbookEntry.distance || self.logbookEntry.duration)
    {
        self.slotOneLabel.text = @"Pace";
        self.slotOneColOne.text = self.logbookEntry.pace;
        
        self.slotTwoLabel.text = @"Duration";
        self.slotTwoColOne.text = self.logbookEntry.duration;
        
        self.slotThreeLabel.text = @"Distance";
        self.slotThreeColOne.text = self.logbookEntry.distance;
    }
    else
    {
        self.slotOneLabel.text = @"Weight";
        self.slotOneColOne.text = self.logbookEntry.weight;
        
        self.slotTwoLabel.text = @"Sets";
        self.slotTwoColOne.text = self.logbookEntry.sets;
        
        self.slotThreeLabel.text = @"Reps";
        self.slotThreeColOne.text = self.logbookEntry.reps;   
    }
    
    self.colOneDate.text = [self tinyDateFormat:self.logbookEntry.date format:@"MM/dd/yy"];
}


-(void) loadLastEntryFromLogbook
{
    NSString *exerciseName = self.logbookEntry.exercise_name;
    NSDate *entryDate = [self.logbookEntry.date copy];
    NSFetchedResultsController *frc;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(exercise_name = %@) AND (date < %@) AND (completed = %@)", 
                         exerciseName, entryDate, [NSNumber numberWithBool:YES]];
    
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                              managedObjectContext:[[AppDelegate sharedAppDelegate] managedObjectContext]
                                                sectionNameKeyPath:nil 
                                                         cacheName:nil];
    NSError *error;
    [frc performFetch:&error];
    NSLog(@"Retrieving logbook");
    
    NSArray *array = [frc fetchedObjects];
    LogbookEntry *theEntry;
    
    if (array && array.count > 0)
    {
        theEntry = (LogbookEntry *)[array lastObject];
        
        self.colTwoDate.text = [self tinyDateFormat:theEntry.date format:@"MM/dd/yy"];
        
        if (theEntry.pace || theEntry.distance || theEntry.duration)
        {
            self.slotOneColTwo.text = theEntry.pace;
            self.slotTwoColTwo.text = theEntry.duration;
            self.slotThreeColTwo.text = theEntry.distance;
        }
        else
        {
            self.slotOneColTwo.text = theEntry.weight;
            self.slotTwoColTwo.text = theEntry.sets;
            self.slotThreeColTwo.text = theEntry.reps;   
        }  
        
    }
    else
    {
        self.colTwoDate.text = [self tinyDateFormat:theEntry.date format:@"--/--/--"];
        self.slotOneColTwo.text = @"-";
        self.slotTwoColTwo.text = @"-";
        self.slotThreeColTwo.text = @"-"; 
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    // Data stuff
    [self loadFormDataFromLogbook];
    
    // Last Entry
    [self loadLastEntryFromLogbook];
}

- (void)viewDidUnload {
    [self setEntryDate:nil];
    [self setEntryName:nil];
    [self setSlotOneLabel:nil];
    [self setSlotTwoLabel:nil];
    [self setSlotThreeLabel:nil];
    [self setColOneDate:nil];
    [self setColTwoDate:nil];
    [self setSlotOneColOne:nil];
    [self setSlotTwoColOne:nil];
    [self setSlotThreeColOne:nil];
    [self setSlotOneColTwo:nil];
    [self setSlotTwoColTwo:nil];
    [self setSlotThreeColTwo:nil];
    [super viewDidUnload];
}
@end
