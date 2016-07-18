#import "Flurry.h"

@class CountdownDetailViewController;
@class CountupDetailViewController;

@interface CountdownDetailOptionsViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *timesetButton;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet UITextView *targetDateField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextView *startDateField;

@property Countdown *currentCountdown;
@property NSMutableArray *timesets;
@property NSTimer *delayTimer;
@property NSTimer *varTimer;
@property NSTimer *timer;
@property UIDatePicker *datePickerPointer;
@property UISegmentedControl *barButtonPointer;
@property int changeButton;
@property CountdownDetailViewController *subviewController;

- (IBAction)callDP:(id)sender;

- (IBAction)switchTimeset:(id)sender;
- (IBAction)switchUnits:(id)sender;
- (IBAction)showUnitHelp:(id)sender;
- (IBAction)nameChanged:(id)sender;

- (IBAction)loadCountdownDetailView:(id)sender;

- (void)updateUI;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
