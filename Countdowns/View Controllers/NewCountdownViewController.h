#import "Flurry.h"

@interface NewCountdownViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property NSMutableArray *countdowns;
@property NSMutableArray *timesets;
@property Timeset *currentTimeset;
@property NSTimer *varTimer;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *timesetButton;

- (IBAction)switchDatePicker:(id)sender;
- (IBAction)createCountdown:(id)sender;
- (IBAction)switchTimeset:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)viewWillAppear:(BOOL)animated;

- (IBAction)loadCountdownsView:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
