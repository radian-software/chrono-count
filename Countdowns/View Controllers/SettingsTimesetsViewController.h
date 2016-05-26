//
//  SettingsTimesetsViewController.h
//  Countdowns
//
//  Created by raxod502 on 6/3/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

@interface SettingsTimesetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property NSMutableArray *timesets;
@property NSMutableArray *countdowns;
@property Timeset *viewedTimeset;
@property NSTimer *varTimer;
@property int currentIndex;
@property NSMutableArray *countups;

- (IBAction)editButtonClicked:(id)sender;
- (IBAction)addButtonClicked:(id)sender;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)loadSettingsView:(id)sender;
- (void)loadSettingsNewTimesetView:(id)sender;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)hideTabBar;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
