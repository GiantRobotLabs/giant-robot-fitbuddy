//
//  ExerciseControlController.h
//  GymBuddy
//
//  Created by John Neyer on 2/18/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"
#import "GymBuddyMacros.h"

@interface ExerciseControlController : UIViewController

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *slotOneValue;
@property (weak, nonatomic) IBOutlet UILabel *slotTwoValue;
@property (weak, nonatomic) IBOutlet UILabel *slotThreeValue;
@property (weak, nonatomic) IBOutlet UILabel *slotOneIncrementValue;
@property (weak, nonatomic) IBOutlet UILabel *slotOneTitle;
@property (weak, nonatomic) IBOutlet UILabel *slotTwoTitle;
@property (weak, nonatomic) IBOutlet UILabel *slotThreeTitle;

@property (nonatomic, strong) Exercise *exercise;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void) loadFormDataFromExerciseObject;
-(void) setExerciseFromForm;


@end
