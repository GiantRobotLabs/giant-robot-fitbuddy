//
//  AddExerciseViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/2/12.
//  Copyright (c) 2012 Accenture National Security Services. All rights reserved.
//

#import "AddExerciseViewController.h"
#import "CoreDataHelper.h"

@implementation AddExerciseViewController

@synthesize addExerciseField = _addExerciseField;
@synthesize exercise = _exercise;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void) viewDidAppear:(BOOL)animated
{
    [self.addExerciseField addTarget:self
                              action:@selector(newExerciseTextFieldFinished:)
                    forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) newExerciseTextFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void) setExercise:(Exercise *)exercise
{
    _exercise = exercise;
}

- (IBAction)addExercise:(UITextField *)sender
{
    self.exercise.name = sender.text;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([self.addExerciseField.text isEqualToString:@""]) 
    {
        if (DEBUG) NSLog(@"Deleting Exercise object %@", self.exercise);
        [[CoreDataHelper getActiveManagedObjectContext] deleteObject:self.exercise];
    }    
}

@end
