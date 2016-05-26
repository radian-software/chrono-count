//
//  TabBarViewController.m
//  Countdowns
//
//  Created by raxod502 on 7/1/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

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
