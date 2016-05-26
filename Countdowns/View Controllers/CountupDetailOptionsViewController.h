//
//  CountupDetailOptionsViewController.h
//  Countdowns
//
//  Created by raxod502 on 7/7/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "Flurry.h"

@class CountupDetailViewController;

@interface CountupDetailOptionsViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *timesetButton;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet UITextView *targetDateField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property Countdown *currentCountdown;
@property NSMutableArray *timesets;
@property NSTimer *timer;
@property NSTimer *delayTimer;
@property NSTimer *varTimer;
@property UIDatePicker *datePickerPointer;
@property UISegmentedControl *barButtonPointer;
@property CountupDetailViewController *subviewController;

- (IBAction)callDP:(id)sender;

- (IBAction)switchTimeset:(id)sender;
- (IBAction)switchUnits:(id)sender;
- (IBAction)showUnitHelp:(id)sender;
- (IBAction)nameChanged:(id)sender;

- (IBAction)loadCountdownDetailView:(id)sender;

- (void)updateUI;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)recalculateCountdown2;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
