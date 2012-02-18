//
//  GymBuddyViewController.m
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "GymBuddyViewController.h"
#import "CoreDataHelper.h"
#import "CardioExercise.h"
#import "ResistanceExercise.h"


@implementation GymBuddyViewController
@synthesize slotOneValue = _weightLabel;
@synthesize slotTwoValue = _repsLabel;
@synthesize slotThreeValue = _setsLabel;
@synthesize slotOneIncrementValue = _weightIncrementLabel;
@synthesize nameLabel = _nameLabel;
@synthesize slotOneTitle = _slotOneTitle;
@synthesize slotTwoTitle = _slotTwoTitle;
@synthesize slotThreeTitle = _slotThreeTitle;

@synthesize exercise = _exercise;

@synthesize fetchedResultsController = _fetchedResultsController;

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.exercise.name];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                            managedObjectContext:[CoreDataHelper getActiveManagedObjectContext]
                                                                              sectionNameKeyPath:nil 
                                                                                    cacheName:nil];
}

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    [self setupFetchedResultsController];
}

-(void) viewWillAppear:(BOOL)animated
{
    // Initialize
    [self.nameLabel addTarget:self action:@selector(finishedEditingNameLabel:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self loadDataFromExerciseObject];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.slotOneValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.slotThreeValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.slotTwoValue.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
}

-(void) loadDataFromExerciseObject
{
    self.nameLabel.text = self.exercise.name;
    
    NSEntityDescription *desc = self.exercise.entity;
    
    NSLog (@"%@", desc.name);
    
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        // Relabel
        self.slotOneTitle.text = @"Pace";
        self.slotTwoTitle.text = @"Duration";
        self.slotThreeTitle.text = @"Distance";
        
        // Values
        self.slotThreeValue.text = ((CardioExercise *)self.exercise).pace;
        self.slotOneIncrementValue.text = @"0.5";
        self.slotTwoValue.text = ((CardioExercise *)self.exercise).duration;
        self.slotOneValue.text = ((CardioExercise *)self.exercise).distance;
    }
    else
    {
        // Labels
        self.slotOneTitle.text = @"Weight";
        self.slotTwoTitle.text = @"Reps";
        self.slotThreeTitle.text = @"Sets";
        
        //Values
        self.slotOneValue.text = ((ResistanceExercise *)self.exercise).weight;
        self.slotTwoValue.text = ((ResistanceExercise *)self.exercise).reps;
        self.slotThreeValue.text = ((ResistanceExercise *)self.exercise).sets;
    }
    
}

-(void) setExerciseFromForm
{
    self.exercise.name = self.nameLabel.text;
    
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        ((CardioExercise *)self.exercise).pace = self.slotThreeValue.text;
        ((CardioExercise *)self.exercise).duration = self.slotTwoValue.text;
        ((CardioExercise *)self.exercise).distance = self.slotOneValue.text; 
    }
    else
    {
        ((ResistanceExercise *)self.exercise).weight = self.slotOneValue.text;
        ((ResistanceExercise *)self.exercise).reps = self.slotTwoValue.text;
        ((ResistanceExercise *)self.exercise).sets = self.slotThreeValue.text;
    }
}

- (IBAction)slotOneIncrement:(UIButton *)sender {
    double increment = [self.slotOneIncrementValue.text doubleValue];
    double val = [self.slotOneValue.text doubleValue];
    
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += increment;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (val >= increment) val -= increment;
    }
    self.slotOneValue.text = [NSString stringWithFormat:@"%g", val];
}

- (IBAction)slotTwoIncrement:(UIButton *)sender {
    double val = [self.slotTwoValue.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (val >= 1) val -= 1;
    }
    self.slotTwoValue.text = [NSString stringWithFormat:@"%g", val];
}

- (IBAction)slotThreeIncrement:(UIButton *)sender {
    double val = [self.slotThreeValue.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (val >= 1) val -= 1;
    }
    self.slotThreeValue.text = [NSString stringWithFormat:@"%g", val];
}

- (IBAction)undoAllDataChangesSinceLastSave 
{
    [self loadDataFromExerciseObject];
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
