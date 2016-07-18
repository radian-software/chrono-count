#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

@class CountdownsViewController;
@class CountupsViewController;

@interface SettingsViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property UITableView *tableView;

@property NSTimer *varTimer;
@property BOOL fromCountdowns;
@property CountdownsViewController *delegateController;
@property CountupsViewController *delegateController2;

NSString *machineName();
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

- (IBAction)backButtonPressed:(id)sender;

- (void)globalizeVariables;
- (void)retrieveVariables;

@end
