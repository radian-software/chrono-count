//
//  SettingsViewController.m
//  Countdowns
//
//  Created by raxod502 on 7/31/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "SettingsViewController.h"

#import "CountdownsViewController.h"
#import "CountupsViewController.h"

#import "Flurry.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

NSString *machineName() {
	struct utsname systemInfo;
	uname(&systemInfo);
	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
		[Flurry logEvent:@"Viewed_Website"];
		NSURL *url = [NSURL URLWithString:@"http://www.apprisingsoftware.com/chrono-count/"];
		[[UIApplication sharedApplication] openURL:url];
	}
	if ([indexPath section] == 1 && [indexPath row] == 0) {
		[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *controller = [MFMailComposeViewController new];
			[controller setMailComposeDelegate:self];
			[controller setSubject:@"Chrono Count Feedback"];
			[controller setMessageBody:[NSString stringWithFormat:@"\n\nChrono Count Version: %@ (%@)\niOS Version: %@ (%@)", [[NSUserDefaults standardUserDefaults] objectForKey:@"version"], [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], machineName()] isHTML:NO];
			[controller setToRecipients:[NSArray arrayWithObject:@"support@apprisingsoftware.com"]];
			[self presentViewController:controller animated:YES completion:nil];
		}
		else {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Can't send mail! Please check if you have an email account enabled on this device." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
			[actionSheet showInView:[self view]];
		}
//		NSURL *url = [NSURL URLWithString:@"http://www.apprisingsoftware.com/support/"];
//		[[UIApplication sharedApplication] openURL:url];
	}
	if ([indexPath section] == 2 && [indexPath row] == 0) {
		[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
		[self performSegueWithIdentifier:@"loadTutorialView" sender:tableView];
	}
	if ([indexPath section] == 3 && [indexPath row] == 0) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Warning! This action will delete all countdowns, countups, and timesets currently stored in this app. Are you sure you want to continue?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:nil];
		[actionSheet showInView:[self view]];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear"]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This is the last chance to cancel! Are you ABSOLUTELY sure you want to continue?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Continue" otherButtonTitles:nil];
		[actionSheet showInView:[self view]];
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue"]) {
		[[self tableView] deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] animated:YES];
		[Flurry logEvent:@"Clear_All_Data"];
        [[Shared shared] reset];
		[[self delegateController] retrieveVariables];
		[[self delegateController2] retrieveVariables];
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
		[[self tableView] deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:NO animated:animated];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (IBAction)backButtonPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
	[[self delegateController] viewWillAppear:YES];
	[[self delegateController2] viewWillAppear:YES];
}

- (void)globalizeVariables {
	[Shared setCurrentTab:![self fromCountdowns]];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setFromCountdowns:[Shared fromCountdowns]];
	// END RETRIEVAL
}

@end
