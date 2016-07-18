#import "UIView+AncestorSearch.h"

@implementation UIView (AncestorSearch)

- (UIView *)ancestorViewOfType:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	}
	else if ([self superview]) {
		return [[self superview] ancestorViewOfType:cls];
	}
	else {
		return nil;
	}
}

@end
