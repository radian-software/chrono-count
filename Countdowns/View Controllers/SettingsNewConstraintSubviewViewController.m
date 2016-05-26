//
//  SettingsNewConstraintSubviewViewController.m
//  Countdowns
//
//  Created by raxod502 on 6/7/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "SettingsNewConstraintSubviewViewController.h"

#import "SettingsViewController.h"
#import "SettingsNewConstraintViewController.h"

@interface SettingsNewConstraintSubviewViewController ()

@end

@implementation SettingsNewConstraintSubviewViewController

- (SettingsNewConstraintViewController *)getSuperview {
	for (UIView *next = [[self view] superview]; next; next = [next superview]) {
		UIResponder *respond = [next nextResponder];
		if ([respond isKindOfClass:[SettingsNewConstraintViewController class]]) {
			return (SettingsNewConstraintViewController *)respond;
		}
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self getSuperview] tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self getSuperview] tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

@end
