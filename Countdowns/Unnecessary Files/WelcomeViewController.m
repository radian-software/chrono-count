//
//  WelcomeViewController.m
//  Countdowns
//
//  Created by raxod502 on 8/21/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (IBAction)start:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"welcome"];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
