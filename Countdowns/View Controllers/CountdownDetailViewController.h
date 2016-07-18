@class CountdownDetailOptionsViewController;
@class CountupDetailViewController;

@interface CountdownDetailViewController : UIViewController <UIActionSheetDelegate>

@property NSMutableArray *countdowns;
@property Countdown *currentCountdown;
@property NSTimer *timer;
@property NSMutableArray *timesets;
@property UIDatePicker *datePickerPointer;
@property UIBarButtonItem *barButtonPointer;
@property NSTimer *delayTimer;
@property NSTimer *varTimer;
@property BOOL switchTab;

@property (weak, nonatomic) IBOutlet UITextView *timeRemainingField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *toggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)moveToCountups:(id)sender;
- (IBAction)switchCountdown:(id)sender;
- (IBAction)editCountdownPressed:(id)sender;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)updateUI;
+ (BOOL)testForBoundaryWithComps:(NSDateComponents *)comps andDelay:(int)delay; // ... Apparently not.
+ (NSDateComponents *)nextIndexFromComps:(NSDateComponents *)comps withDelay:(int)delay;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (IBAction)loadCountdownsView:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
