#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	if (![Shared skipAppear]) {
		[self setSelectedIndex:[Shared currentTab]];
	}
}

@end
