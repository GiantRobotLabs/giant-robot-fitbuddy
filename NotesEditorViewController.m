//
//  NotesEditorViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/4/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "NotesEditorViewController.h"

@implementation NotesEditorViewController

@synthesize notesTextView = _notesTextView;

@synthesize exercise = _exercise;
@synthesize fetchedResultsController = _fetchedResultsController;

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.exercise.name];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.exercise.managedObjectContext
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

- (void) setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    
    [self setupFetchedResultsController];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void) doneAction: (id) sender
{ 
    [self.notesTextView resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.notesTextView.text = self.exercise.notes;
    NSLog(@"loaded data for %@", self.exercise.name);
    
}

-(void) viewWillDisappear:(BOOL)animated
{
   self.exercise.notes = self.notesTextView.text; 
}

@end
