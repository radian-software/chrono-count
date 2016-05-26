//
//  SettingsNewTimesetViewController.h
//  Countdowns
//
//  Created by raxod502 on 6/3/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "Flurry.h"

@class CountupDetailViewController;

@interface SettingsNewTimesetViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property NSMutableArray *timesets;
@property Timeset *currentTimeset;
@property NSTimer *delayTimer;
@property NSTimer *varTimer;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *notCopyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)createTimeset:(id)sender;
- (IBAction)clearTimeset:(id)sender;
- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)nameChanged:(id)sender;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (IBAction)loadSettingsTimesetsView:(id)sender;
- (IBAction)loadSettingsNewConstraintView:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
