//
//  SettingsSubviewViewController.m
//  Countdowns
//
//  Created by raxod502 on 7/31/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "SettingsSubviewViewController.h"

@interface SettingsSubviewViewController ()

@end

@implementation SettingsSubviewViewController

- (SettingsViewController *)getSuperview {
	for (UIView *next = [[self view] superview]; next; next = [next superview]) {
		UIResponder *respond = [next nextResponder];
		if ([respond isKindOfClass:[SettingsViewController class]]) {
			return (SettingsViewController *)respond;
		}
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self getSuperview] setTableView:tableView];
	[[self getSuperview] tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self getSuperview] setTableView:tableView];
//	[[self getSuperview] tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 1) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [tableView frame].size.width, 50)];
		[view setBackgroundColor:[UIColor clearColor]];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, [tableView frame].size.width, 25)];
		[label setCenter:[tableView center]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setText:@"Chrono Count 1.0 for iPhone."];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		[view addSubview:label];
		return view;
	}
	return nil;
}

- (void)viewWillAppear:(BOOL)animated {
	//
}

@end
