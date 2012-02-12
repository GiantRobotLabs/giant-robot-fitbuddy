//
//  GymBuddyViewController.m
//  GymBuddy
//
//  Created by John Neyer on 1/30/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "GymBuddyViewController.h"

@implementation GymBuddyViewController
@synthesize weightLabel = _weightLabel;
@synthesize repsLabel = _repsLabel;
@synthesize setsLabel = _setsLabel;
@synthesize weightIncrementLabel = _weightIncrementLabel;
@synthesize nameLabel = _nameLabel;

@synthesize exercise = _exercise;

@synthesize fetchedResultsController = _fetchedResultsController;

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_TABLE];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.exercise.name];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                            managedObjectContext:self.exercise.managedObjectContext
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
    self.weightLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.setsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.repsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
}

-(void) loadDataFromExerciseObject
{
    self.nameLabel.text = self.exercise.name;
    self.setsLabel.text =self.exercise.sets;
    self.repsLabel.text = self.exercise.reps;
    self.weightLabel.text = self.exercise.weight;
}

- (IBAction)weightIncrement:(UIButton *)sender {
    double increment = [self.weightIncrementLabel.text doubleValue];
    double weight = [self.weightLabel.text doubleValue];
    
    if ([@"+" isEqualToString:sender.currentTitle]) {
        weight += increment;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (weight >= increment) weight -= increment;
    }
    self.weightLabel.text = [NSString stringWithFormat:@"%g", weight];
}

- (IBAction)repsIncrement:(UIButton *)sender {
    double reps = [self.repsLabel.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        reps += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (reps >= 1) reps -= 1;
    }
    self.repsLabel.text = [NSString stringWithFormat:@"%g", reps];
}

- (IBAction)setsIncrement:(UIButton *)sender {
    double sets = [self.setsLabel.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        sets += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        if (sets >= 1) sets -= 1;
    }
    self.setsLabel.text = [NSString stringWithFormat:@"%g", sets];
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
    self.exercise.name = self.nameLabel.text;
    self.exercise.weight = self.weightLabel.text;
    self.exercise.reps = self.repsLabel.text;
    self.exercise.sets = self.setsLabel.text;
}

@end
