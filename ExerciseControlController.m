//
//  ExerciseControlController.m
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "ExerciseControlController.h"
#import "CardioExercise.h"
#import "ResistanceExercise.h"
#import "CoreDataTableViewController.h"

@implementation ExerciseControlController

@synthesize slotOneValue = _weightLabel;
@synthesize slotTwoValue = _repsLabel;
@synthesize slotThreeValue = _setsLabel;
@synthesize slotOneIncrementValue = _weightIncrementLabel;

@synthesize slotOneTitle = _slotOneTitle;
@synthesize slotTwoTitle = _slotTwoTitle;
@synthesize slotThreeTitle = _slotThreeTitle;

@synthesize exercise = _exercise;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void) setupFetchedResultsController
{
    // Override me please
}

-(void) loadFormDataFromExerciseObject
{
    NSEntityDescription *desc = self.exercise.entity;
    
    NSLog (@"%@", desc.name);
    
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        // Relabel
        self.slotOneTitle.text = @"Pace";
        self.slotTwoTitle.text = @"Duration";
        self.slotThreeTitle.text = @"Distance";
        
        // Values
        self.slotOneValue.text = ((CardioExercise *)self.exercise).pace;
        self.slotOneIncrementValue.text = @"0.5";
        self.slotTwoValue.text = ((CardioExercise *)self.exercise).duration;
        self.slotThreeValue.text = ((CardioExercise *)self.exercise).distance;
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
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"])
    {
        ((CardioExercise *)self.exercise).pace = self.slotOneValue.text;
        ((CardioExercise *)self.exercise).duration = self.slotTwoValue.text;
        ((CardioExercise *)self.exercise).distance = self.slotThreeValue.text; 
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
    [self loadFormDataFromExerciseObject];
}


@end
