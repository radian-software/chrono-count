//
//  UIView+AncestorSearch.m
//  Countdowns
//
//  Created by raxod502 on 12/1/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

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
