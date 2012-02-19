//
//  AddExerciseViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "ExerciseAddViewController.h"
#import "CoreDataHelper.h"
#import "Exercise.h"

@implementation ExerciseAddViewController

@synthesize addExerciseField = _addExerciseField;
@synthesize exerciseTypeToggle = _exerciseTypeToggle;

-(void) viewDidAppear:(BOOL)animated
{
    [self.addExerciseField addTarget:self
                              action:@selector(newExerciseTextFieldFinished:)
                    forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) newExerciseTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.exerciseTypeToggle.backgroundColor = [UIColor clearColor];
    self.exerciseTypeToggle.tintColor = GYMBUDDY_BROWN;
}

-(void) createExercise
{
    if (![self.addExerciseField.text isEqualToString:@""]) 
    {
        Exercise *exercise = nil;
        
        if (self.exerciseTypeToggle.selectedSegmentIndex == 0)
        {
            exercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:RESISTANCE_EXERCISE_TABLE 
                                                     inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
            
        }
        else
        {
            exercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:CARDIO_EXERCISE_TABLE 
                                                                 inManagedObjectContext:[CoreDataHelper getActiveManagedObjectContext]];
            
        }
        
         exercise.name = self.addExerciseField.text;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self createExercise];
}

- (void)viewDidUnload {
    [self setExerciseTypeToggle:nil];
    [super viewDidUnload];
}

@end
