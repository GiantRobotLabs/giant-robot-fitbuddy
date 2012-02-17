//
//  GymbuddyMacros.h
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#ifndef GymBuddy_GymbuddyMacros_h
#define GymBuddy_GymbuddyMacros_h

// DEBUG - Defined in Xcode project settings
//#define DEBUG               YES

// DATABASE
#define DATABASE            @"GymBuddy"
#define EXERCISE_TABLE      @"Exercise"
#define WORKOUT_TABLE       @"Workout"
#define LOGBOOK_TABLE       @"LogbookEntry"

// IMAGES
#define BACKGROUND_IMAGE    @"gb-background.png"
#define TITLEBAR_IMAGE      @"gb-titlebar.png"
#define GB_BACKGROUND_CHROME @"gb-background-chrome.png"
#define GB_TITLEBAR_CHROME  @"gb-titlebar-chrome.png"
#define GB_BG_CHROME_BOTTOM @"background-chrome-bottom.png"
#define CELL_IMAGE          @"gb-cell.png"
#define BUTTON_IMAGE        @"gb-button.png"
#define BUTTON_IMAGE_DARK   @"gb-button-dark.png"
#define TEXTFIELD_IMAGE     @"gb-textfield.png"
#define UNDO_IMAGE          @"gb-undo.png"
#define BACKGROUND_IMAGE_LONG @"gb-background-long.png"
#define CHECK_IMAGE         @"sm-checked.png"
#define UNCHECKED_IMAGE     @"sm-unchecked.png"
#define SUCCESS_IMAGE       @"success.png"
#define UNWORKOUT_IMAGE     @"unworkout.png"
#define BUTTON_IMAGE_DARK_LG @"gb-button-dark-big.png"
#define BUTTON_IMAGE_LG     @"gb-button-big.png"
#define GB_RED_IMAGE        @"red.png"
#define GB_BLACK_IMAGE      @"black.png"
#define BACKGROUND_IMAGE_UI @"gb-background-ui2.png"


// SEGUES
#define ADD_EXERCISE_SEGUE  @"Add Exercise Segue"
#define ADD_WORKOUT_SEGUE   @"Add Workout Segue"
#define START_WORKOUT_SEGUE @"Start Workout Segue"
#define WORKOUT_MODE_SEGUE  @"Segue To Me"
#define WORKOUT_REVERSE_SEGUE  @"Go Back To Me Segue"
#define GO_HOME_SEGUE       @"Go Home Segue"
#define NOTES_SEGUE         @"Segue To Notes"

// COLORS
#define GYMBUDDY_RED        [UIColor colorWithRed:158.0/255.0 green:37.0/255.0 blue:33.0/255.0 alpha:1]
#define GYMBUDDY_GREEN      [UIColor colorWithRed:33.0/255.0 green:158.0/255.0 blue:74.0/255.0 alpha:1]
#define GYMBUDDY_YELLOW     [UIColor colorWithRed:241.0/255.0 green:191.0/255.0 blue:40.0/255.0 alpha:1]
#endif
