//
//  SettingsNewConstraintViewController.h
//  Countdowns
//
//  Created by raxod502 on 6/4/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#define END -51
#define SUICIDE 0/0

@interface SettingsNewConstraintViewController : UIViewController <UIActionSheetDelegate>

@property Timeset *currentTimeset;

@property UITableView *tableView;
@property NSIndexPath *lastCell;
@property Constraint *currentConstraint;
@property Qualifier *qualifierProgress;
@property NSTimer *varTimer;
@property NSMutableArray *holidays;
@property IntegerArray *tempList;

@property (weak, nonatomic) IBOutlet UITextView *descView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *excludeIncludeSwitch;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)makeDescription;
- (int)findSumOfBools:(BOOL)firstArg, ...;
- (BOOL)checkForQuota:(int)quota inBools:(BOOL)firstArg, ...;

- (IBAction)loadSettingsNewTimesetView:(id)sender;
- (IBAction)addConstraint:(id)sender;
- (IBAction)excludeIncludeChanged:(id)sender;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)globalizeVariables;
- (void)retrieveVariables;
- (void)selectCells;

@end
