//
//  NotesEditorViewController.h
//  GymBuddy
//
//  Created by John Neyer on 2/4/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

#import "GymBuddyMacros.h"

@interface NotesEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (nonatomic, strong) Exercise *exercise;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
