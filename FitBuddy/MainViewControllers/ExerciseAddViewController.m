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

-(void) viewDidLoad
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
}

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
   
}

-(void) createExercise
{
    if (![self.addExerciseField.text isEqualToString:@""]) 
    {
        NSManagedObjectContext *context = [CoreDataHelper getActiveManagedObjectContext];
        NSManagedObject *newExercise;

        if (self.exerciseTypeToggle.selectedSegmentIndex == 0)
        {
            newExercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:RESISTANCE_EXERCISE_TABLE inManagedObjectContext:context];
            
        }
        else
        {
            newExercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:CARDIO_EXERCISE_TABLE inManagedObjectContext:context];
            
        }
        
        [newExercise setValue:self.addExerciseField.text forKey:@"name"];
        self.addExerciseField.text = @"";
        
        NSError *error;
        [context save:&error];
        if (DEBUG) NSLog(@"Exercise created");
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
