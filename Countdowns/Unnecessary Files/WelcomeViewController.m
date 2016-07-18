#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (IBAction)start:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"welcome"];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
