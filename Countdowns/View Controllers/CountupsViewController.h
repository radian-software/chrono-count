#import "UIView+AncestorSearch.h"

@class CountupDetailViewController;
@class SettingsViewController;

@interface CountupsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property NSMutableArray *countdowns;
@property Countdown *currentCountdown;
@property NSMutableArray *timesets;
@property NSTimer *timer;
@property NSTimer *varTimer;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateUI;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidLayoutSubviews;

- (IBAction)loadNewCountupView:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
