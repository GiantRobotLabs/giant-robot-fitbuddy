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
    //if (DEBUG) NSLog(@"Loaded notes data for %@", self.exercise.name);
}

-(void) viewWillDisappear:(BOOL)animated
{
   self.exercise.notes = self.notesTextView.text; 
}

@end
