//
//  FitBuddyMacros.h
//  FitBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#ifndef FitBuddy_FitBuddyMacros_h
#define FitBuddy_FitBuddyMacros_h

// DEBUG - Defined in Xcode project settings
//#define DEBUG               YES

// DATABASE
#define kDATABASE2_0        @"FitBuddy.sqlite"
#define kDATABASE1_0        @"GymBuddy"
#define kEXPORTNAME         @"FitBuddy"
#define kEXPORTEXT          @".gbz"

#define EXERCISE_TABLE      @"Exercise"
#define WORKOUT_TABLE       @"Workout"
#define LOGBOOK_TABLE       @"LogbookEntry"
#define CARDIO_EXERCISE_TABLE @"CardioExercise"
#define RESISTANCE_EXERCISE_TABLE @"ResistanceExercise"

// DEFAULTS KEYS
#define kDATAVERSIONKEY     @"DataVersion"
#define kDATAVERSION        @"2.0"
#define kUSEICLOUDKEY       @"Use iCloud"
#define kYES                @"Yes"
#define kNO                 @"No"
#define kEXPORTDBKEY        @"Export Database"
#define kITUNES             @"iTunes"

// NOTIFICATIONS
#define kCHECKBOXTOGGLED    @"CheckboxToggled"

// NEW_ASSETS
#define kTITLEBAR            @"titlebar"
#define kFITBUDDY            @"fitbuddy"
#define kSTART               @"start-button"
#define kSTARTDISABLED       @"start-disabled"
#define kCARDIO              @"toggle-run"
#define kRESISTANCE          @"toggle-workout"
#define kCARDIOW             @"workout-run"
#define kRESISTANCEW         @"workout-resistance"

#define kCOLOR_RED        [UIColor colorWithRed:222.0/255.0 green:11.0/255.0 blue:25.0/255.0 alpha:1]
#define kCOLOR_GRAY       [UIColor colorWithRed:173.0/255.0 green:175.0/255.0 blue:178.0/255.0 alpha:1]

// IMAGES
#define BACKGROUND_IMAGE    @"gb-background.png"
#define TITLEBAR_IMAGE      @"titlebar"
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
#define UNWORKOUT_IMAGE     @"unworkout.png"
#define BUTTON_IMAGE_DARK_LG @"gb-button-dark-big.png"
#define BUTTON_IMAGE_LG     @"gb-button-big.png"
#define GB_RED_IMAGE        @"red.png"
#define GB_BLACK_IMAGE      @"black.png"
#define BACKGROUND_IMAGE_UI @"gb-background-ui2.png"
#define GB_CHECK_WHITE      @"check-transparent.png"
#define GB_CARDIO_IMAGE     @"run.png"
#define GB_RESISTANCE_IMAGE @"workout-transparent.png"
#define GB_CHROME_WO_TB     @"tb-chrome-workout.png"
#define GB_CHROME_WO_BG     @"bg-chrome-workout.png"
#define GB_CHROME_CAR_TB    @"tb-chrome-cardio.png"
#define GB_CHROME_CAR_BG    @"bg-chrome-cardio.png"
#define GB_GREENSTAT_PLUS   @"gb-green-plus.png"
#define GB_GREENSTAT        @"gb-green.png"
#define GB_REDSTAT          @"gb-orange.png"
#define kCHECKTRANSPARENT    @"check-transparent"

// SEGUES
#define ADD_EXERCISE_SEGUE  @"Add Exercise Segue"
#define ADD_WORKOUT_SEGUE   @"Add Workout Segue"
#define START_WORKOUT_SEGUE @"Start Workout Segue"
#define WORKOUT_MODE_SEGUE  @"Segue To Me"
#define WORKOUT_REVERSE_SEGUE  @"Go Back To Me Segue"
#define GO_HOME_SEGUE       @"Go Home Segue"
#define NOTES_SEGUE         @"Segue To Notes"

// COLORS
#define GYMBUDDY_RED        [UIColor colorWithRed:222.0/255.0 green:11.0/255.0 blue:25.0/255.0 alpha:1]
//#define GYMBUDDY_GREEN      [UIColor colorWithRed:33.0/255.0 green:158.0/255.0 blue:74.0/255.0 alpha:1]
#define GYMBUDDY_GREEN      [UIColor colorWithRed:140.0/255.0 green:197.0/255.0 blue:65.0/255.0 alpha:1]
#define GYMBUDDY_YELLOW     [UIColor colorWithRed:241.0/255.0 green:191.0/255.0 blue:40.0/255.0 alpha:1]
#define GYMBUDDY_BROWN      [UIColor colorWithRed:194.0/255.0 green:181.0/255.0 blue:155.0/255.0 alpha:1]
#define GYMBUDDY_DK_BROWN   [UIColor colorWithRed:114.0/255.0 green:102.0/255.0 blue:89.0/255.0 alpha:1]
#define GYMBUDDY_CELL_BG    [UIColor colorWithRed:154.0/255.0 green:133.0/255.0 blue:122.0/255.0 alpha:.50]
#endif
