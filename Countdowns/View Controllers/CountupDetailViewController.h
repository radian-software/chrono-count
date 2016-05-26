//
//  CountupDetailViewController.h
//  Countdowns
//
//  Created by raxod502 on 7/4/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "iToast.h"

@class CountdownDetailViewController;
@class CountupDetailOptionsViewController;

@interface CountupDetailViewController : UIViewController <UIActionSheetDelegate>

@property NSMutableArray *countdowns;
@property Countdown *currentCountdown;
@property NSTimer *timer;
@property NSMutableArray *timesets;
@property UIDatePicker *datePickerPointer;
@property UIBarButtonItem *barButtonPointer;
@property NSTimer *delayTimer;
@property NSTimer *varTimer;
@property BOOL switchTab;

@property (weak, nonatomic) IBOutlet UITextView *timeElapsedField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)moveToCountdowns:(id)sender;
- (IBAction)editCountupPressed:(id)sender;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)updateUI;
+ (NSDateComponents *)lastIndexFromComps:(NSDateComponents *)comps withDelay:(int)delay;
+ (NSDateComponents *)lastIndexFromCompsExclusive:(NSDateComponents *)comps withDelay:(int)delay;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (IBAction)loadCountupsView:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
