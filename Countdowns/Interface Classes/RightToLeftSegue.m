#import "RightToLeftSegue.h"

@implementation RightToLeftSegue

- (void)perform {
	CATransition *trans = [CATransition animation];
	[trans setDuration:0.25];
	[trans setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[trans setType:kCATransitionPush];
	[trans setSubtype:kCATransitionFromLeft];
	[[[[[self sourceViewController] navigationController] view] layer] addAnimation:trans forKey:kCATransition];
	[[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
