//
//  GymBuddyViewController.m
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "ExerciseEditViewController.h"
#import "CoreDataHelper.h"
#import "CardioExercise.h"
#import "ResistanceExercise.h"

@implementation ExerciseEditViewController

@synthesize nameLabel = _nameLabel;

NSManagedObjectContext *context;

-(void) setupFetchedResultsController
{
    context = [CoreDataHelper getActiveManagedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.exercise.name];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

- (void) loadFormDataFromExerciseObject
{
    self.nameLabel.text = self.exercise.name;
    [super loadFormDataFromExerciseObject];
}

-(void) setExerciseFromForm
{
    self.exercise.name = self.nameLabel.text;
    [super setExerciseFromForm];
    
    NSError *error;
    [context save:&error];
    NSLog(@"Updating exercise %@", self.exercise.name);
    
}


- (void)setExercise:(Exercise *)exercise
{
    [super setExercise:exercise];
    [self setupFetchedResultsController];
}

-(void) viewDidLoad
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
}


-(void) viewWillAppear:(BOOL)animated
{
    // Initialize
    [self.nameLabel addTarget:self action:@selector(finishedEditingNameLabel:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self loadFormDataFromExerciseObject];
    
}

- (void) finishedEditingNameLabel: (id) sender
{ 
    [self.nameLabel resignFirstResponder];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:self.exercise];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self setExerciseFromForm];
}

- (void)viewDidUnload {
    [self setSlotOneTitle:nil];
    [self setSlotTwoTitle:nil];
    [self setSlotThreeTitle:nil];
    [super viewDidUnload];
}
@end
