//
//  WorkoutModeViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/11/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "WorkoutModeViewController.h"

@implementation WorkoutModeViewController

@synthesize weightLabel = _weightLabel;
@synthesize repsLabel = _repsLabel;
@synthesize setsLabel = _setsLabel;
@synthesize weightIncrementLabel = _weightIncrementLabel;
@synthesize nameValue = _nameValue;
@synthesize pageControl = _pageControl;

@synthesize workout = _workout;
@synthesize exercise = _exercise;
@synthesize exercises = _exercises;
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

-(void) setWorkout:(Workout *)workout
{
    _workout = workout;
    self.exercises = workout.exercises;
    self.exercise = (Exercise *)[self.workout.exercises objectAtIndex:0];
    if (DEBUG) NSLog(@"WorkoutModeController: setWorkout, Exercise = %@", self.exercise);
}

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    [self setupFetchedResultsController];
}

-(void) loadDataFromExerciseObject
{
    self.navigationItem.title = self.exercise.name;
    self.nameValue.text = self.exercise.name;
    self.setsLabel.text =self.exercise.sets;
    self.repsLabel.text = self.exercise.reps;
    self.weightLabel.text = self.exercise.weight;
}

- (IBAction)handleSwipeAction:(UISwipeGestureRecognizer *)sender 
{
    NSUInteger index = [self.exercises indexOfObject:self.exercise];
    if (index == self.exercises.count - 1) index = 0;
    else index += 1;
           
    self.exercise = [self.exercises objectAtIndex:index];
    [self performSegueWithIdentifier: WORKOUT_MODE_SEGUE sender: self];

}


-(void) viewWillAppear:(BOOL)animated
{
    // Initialize
    [self loadDataFromExerciseObject];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.weightLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.setsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.repsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TEXTFIELD_IMAGE]];
    self.pageControl.numberOfPages = self.exercises.count;
    self.pageControl.currentPage = [self.exercises indexOfObject:self.exercise];
    
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];
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


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setWorkout:)]) {
        [segue.destinationViewController performSelector:@selector(setWorkout:) withObject:self.workout];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setExercise:)]) {
        [segue.destinationViewController performSelector:@selector(setExercise:) withObject:self.exercise];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.exercise.weight = self.weightLabel.text;
    self.exercise.reps = self.repsLabel.text;
    self.exercise.sets = self.setsLabel.text;
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [super viewDidUnload];
}
@end
