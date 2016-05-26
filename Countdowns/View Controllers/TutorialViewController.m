//
//  TutorialViewController.m
//  Countdowns
//
//  Created by raxod502 on 7/31/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "TutorialViewController.h"

#import "SettingsNewTimesetViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (IBAction)dismissTutorial:(id)sender {
	[[self currentToast] hide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"secondPrompt"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"If you would like to view the tutorial again, visit the settings page (the gear icon on the Countdowns and Countups screens) to revisit it." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Leave"]) {
        [self dismissTutorial:actionSheet];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"I still don't understand"]) {
		[[self currentToast] hide];
		[self dismissViewControllerAnimated:YES completion:^{[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apprisingsoftware.com/chrono-count/tutorial/"]];}];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Stay"]) {
		[[self scrollView] setHidden:NO];
		CGFloat width = [[self scrollView] frame].size.width;
		[[self scrollView] setContentOffset:CGPointMake(([[self images] count]-1)*width, 0) animated:NO];
		[[self scrollView] setContentOffset:CGPointMake(([[self images] count]-2)*width, 0) animated:YES];
		[self loadVisiblePages];
	}
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)loadVisiblePages {
	return;
	CGFloat width = [[self scrollView] frame].size.width;
	int page = floor(([[self scrollView] contentOffset].x*2.0f + width) / (width*2.0f));
	[[self pageControl] setCurrentPage:page];
	int firstPage = page-1;
	int lastPage = page+1;
	for (int i=0; i<firstPage; i++) {
		[self clearPage:i];
	}
	for (int i=firstPage; i<=lastPage; i++) {
		[self loadPage:i];
	}
	for (int i=lastPage+1; i<[[self images] count]; i++) {
		[self clearPage:i];
	}
}

- (void)loadPage:(int)page {
	if (page < 0 || page >= [[self images] count]) return;
	
	UIView *subview = [[self subviews] objectAtIndex:page];
	if ((NSNull *)subview == [NSNull null]) {
		CGRect frame = [[self scrollView] bounds];
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		
		if ([[self images] objectAtIndex:page] == [NSNull null]) return;
		UIImageView *newSubview = [[UIImageView alloc] initWithImage:[[self images] objectAtIndex:page]];
		[newSubview setContentMode:UIViewContentModeScaleAspectFit];
		[newSubview setFrame:frame];
		[[self scrollView] addSubview:newSubview];
		[[self subviews] replaceObjectAtIndex:page withObject:newSubview];
	}
}

- (void)clearPage:(int)page {
	if (page < 0 || page >= [[self images] count]) return;
	
	UIView *subview = [[self subviews] objectAtIndex:page];
	if ((NSNull *)subview != [NSNull null]) {
		[subview removeFromSuperview];
		[[self subviews] replaceObjectAtIndex:page withObject:[NSNull null]];
	}
}

- (void)loadAllPages {
	for (int i=0; i<[[self images] count]; i++) {
		[self loadPage:i];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self loadVisiblePages];
	[[self currentToast] hide];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat width = [[self scrollView] frame].size.width;
	int page = floor(([[self scrollView] contentOffset].x*2.0f + width) / (width*2.0f));
	if (page == [[self images] count]-1) {
		[[self scrollView] setHidden:YES];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You have finished the tutorial. Would you like to exit?" delegate:self cancelButtonTitle:@"Stay" destructiveButtonTitle:@"Leave" otherButtonTitles:@"I still don't understand", nil];
		[actionSheet showInView:[self scrollView]];
	}
	else {
		CGFloat width = [[self scrollView] frame].size.width;
		int page = floor(([[self scrollView] contentOffset].x*2.0f + width) / (width*2.0f));
		[self setCurrentToast:[iToast makeText:[TEXT objectAtIndex:page]]];
		[[self currentToast] setDuration:NSIntegerMax];
		int tempArray[] = {GRAVITY};
		[[self currentToast] setGravity:tempArray[page]];
		[[self currentToast] show:iToastTypeInfo];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self scrollViewDidEndDecelerating:scrollView];
}

- (void)viewDidLoad {
	if ([[UIScreen mainScreen] bounds].size.height == 480) {
		[[self scrollView] setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20)];
	}
	[self setImages:[NSMutableArray new]];
	for (int i=0; i<[TEXT count]; i++) {
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			[[self images] addObject:[UIImage imageNamed:[NSString stringWithFormat:@"tutorialnot%i.png", i+1]]];
		}
		else {
			if ([[UIScreen mainScreen] bounds].size.height == 568) {
				[[self images] addObject:[UIImage imageNamed:[NSString stringWithFormat:@"tutorialnew%i.png", i+1]]];
			}
			else if ([[UIScreen mainScreen] bounds].size.height == 480) {
				[[self images] addObject:[UIImage imageNamed:[NSString stringWithFormat:@"tutorialned%i.png", i+1]]];
			}
		}
	}
	int count = [[self images] count];
	
	[[self pageControl] setNumberOfPages:count];
	[[self pageControl] setCurrentPage:0];
	
	[self setSubviews:[NSMutableArray new]];
	for (int i=0; i<count; i++) {
		[[self subviews] addObject:[NSNull null]];
	}
}

- (void)viewDidLayoutSubviews {
	CGSize size = [[self scrollView] frame].size;
	[[self scrollView] setContentSize:CGSizeMake(size.width * [[self images] count], size.height)];
}

- (void)viewWillAppear:(BOOL)animated {
    [Flurry logEvent:@"Viewed_Tutorial"];
	[self loadAllPages]; // Because I'm sick and tired of Apple deciding to randomly clip my views.
	[self loadVisiblePages];
	[self scrollViewDidEndDecelerating:[self scrollView]];
}

@end
