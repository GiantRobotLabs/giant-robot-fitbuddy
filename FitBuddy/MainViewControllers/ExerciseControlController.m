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

@interface ExerciseControlController ()
{
    
}
@end

@implementation ExerciseControlController

@synthesize slotOneValue = _weightLabel;
@synthesize slotTwoValue = _repsLabel;
@synthesize slotThreeValue = _setsLabel;
@synthesize slotOneIncrementValue = _weightIncrementLabel;

@synthesize slotOneTitle = _slotOneTitle;
@synthesize slotTwoTitle = _slotTwoTitle;
@synthesize slotThreeTitle = _slotThreeTitle;

@synthesize exercise = _exercise;

BOOL calcDistance;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        calcDistance = YES;
    }
    return self;
}

-(BOOL) isCardio {
    return ([self.exercise.entity.name isEqualToString: @"CardioExercise"]);
}

-(void) loadFormDataFromExerciseObject
{
    NSEntityDescription *desc = self.exercise.entity;
    
    NSLog (@"%@", desc.name);
    
    if ([self isCardio])
    {
        // Relabel
        self.slotOneTitle.text = @"Pace/hr";
        self.slotTwoTitle.text = @"Minutes";
        self.slotThreeTitle.text = @"Distance";
        
        // Values
        NSString *inc = [[NSUserDefaults standardUserDefaults] stringForKey:@"Cardio Increment"];
        if (inc == nil) inc = @"0.5";
        
        self.slotOneValue.text = ((CardioExercise *)self.exercise).pace;
        self.slotOneIncrementValue.text = inc;
        self.slotTwoValue.text = ((CardioExercise *)self.exercise).duration;
        
        //self.slotThreeValue.text = ((CardioExercise *)self.exercise).distance;
        [self calculateSlotThree];
        
    }
    else
    {
        // Labels
        self.slotOneTitle.text = @"Weight";
        self.slotTwoTitle.text = @"Reps";
        self.slotThreeTitle.text = @"Sets";
        
        //Values
        NSString *inc = [[NSUserDefaults standardUserDefaults] stringForKey:@"Resistance Increment"];
        if (inc == nil) inc = @"2.5";
        
        self.slotOneValue.text = ((ResistanceExercise *)self.exercise).weight;
        self.slotOneIncrementValue.text = inc;
        self.slotTwoValue.text = ((ResistanceExercise *)self.exercise).reps;
        self.slotThreeValue.text = ((ResistanceExercise *)self.exercise).sets;
    }
    
}

-(void) setExerciseFromForm
{
    NSEntityDescription *desc = self.exercise.entity;
    if ([desc.name isEqualToString: @"CardioExercise"] == YES)
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

-(void) calculateSlotThree
{
    if ([self isCardio] && self.slotTwoValue.text.doubleValue > 0)
        self.slotThreeValue.text = [NSString stringWithFormat:@"%.1f", (self.slotOneValue.text.doubleValue * 
                                                                    (self.slotTwoValue.text.doubleValue / 60.0))];
    NSLog(@"%@ * %@/60", self.slotThreeValue.text, self.slotTwoValue.text);
    
}

-(void) calculateSlotOne
{
    if ([self isCardio] && self.slotTwoValue.text.doubleValue > 0)
        self.slotOneValue.text = [NSString stringWithFormat:@"%.1f", (self.slotThreeValue.text.doubleValue / 
                                                                        (self.slotTwoValue.text.doubleValue / 60.0))];
    
    NSLog(@"%@ * %@/60", self.slotOneValue.text, self.slotTwoValue.text);
}

- (IBAction)slotOneIncrement:(UIButton *)sender {
    double increment = [self.slotOneIncrementValue.text doubleValue];
    double val = [self.slotOneValue.text doubleValue];
    
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += increment;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        val -= increment;
        if (val < 0) val = 0;
    }
    self.slotOneValue.text = [NSString stringWithFormat:@"%g", val];

    [self calculateSlotThree];
    
    calcDistance = YES;
}

- (IBAction)slotTwoIncrement:(UIButton *)sender {
    double val = [self.slotTwoValue.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += 1;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        val -= 1;
        if (val < 0) val = 0;
    }
    self.slotTwoValue.text = [NSString stringWithFormat:@"%g", val];
    
    if (calcDistance)
        [self calculateSlotThree];
    else
        [self calculateSlotOne];
}

- (IBAction)slotThreeIncrement:(UIButton *)sender {
    
    double increment = 1;
    
    if ([self isCardio])
        increment = [self.slotOneIncrementValue.text doubleValue];
    
    double val = [self.slotThreeValue.text doubleValue];
    if ([@"+" isEqualToString:sender.currentTitle]) {
        val += increment;
    }
    if ([@"-" isEqualToString:sender.currentTitle]) {
        val -= increment;
        if (val < 0) val = 0;
    }
    self.slotThreeValue.text = [NSString stringWithFormat:@"%g", val];
    
    [self calculateSlotOne];
    
    calcDistance = NO;
}

- (IBAction)undoAllDataChangesSinceLastSave 
{
    [self loadFormDataFromExerciseObject];
}


@end
