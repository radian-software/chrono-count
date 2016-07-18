#import "CountupDetailViewController.h"

#import "CountdownDetailViewController.h"
#import "CountupDetailOptionsViewController.h"

#define DISPLAY NO

@interface CountupDetailViewController ()

@end

@implementation CountupDetailViewController

- (IBAction)deleteButtonPressed:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete countup?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)moveToCountdowns:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really move countup?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Move" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)editCountupPressed:(id)sender {
	CountupDetailOptionsViewController *target = [[self storyboard] instantiateViewControllerWithIdentifier:@"countupDetailOptionsView"];
	[self presentViewController:target animated:YES completion:^{[target setSubviewController:self];}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
        [[self currentCountdown] kill];
		[[self countdowns] removeObject:[self currentCountdown]];
		[self loadCountupsView:actionSheet];
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Move"]) {
        [[self currentCountdown] kill];
		[[self countdowns] removeObject:[self currentCountdown]];
		Countdown *newCountdown = [[Countdown alloc] initWithName:[[self currentCountdown] name] date:[[self currentCountdown] date] timeset:[[self currentCountdown] timeset]];
		[[Shared countdowns] addObject:newCountdown];
		[self setSwitchTab:YES];
		[self loadCountupsView:actionSheet];
	}
}

- (void)updateUI {
	if (![[self currentCountdown] date]) return;
	
    [[self currentCountdown] updateCountup];
	
	if ([[[self currentCountdown] displayShort] isEqualToString:CUP_RECALC]) {
		[[self timeElapsedField] setText:[[self currentCountdown] displayLong]];
		[[self moveButton] setHidden:YES];
		return;
	}
	
	[[self moveButton] setHidden:YES];
	[[self imageView] setHidden:[[[[self currentCountdown] timeset] self] invincible]];
	NSString *str = [[self currentCountdown] displayLong];
	
	if ([str isEqualToString:@"This countup has not yet started."]) {
		[[self moveButton] setHidden:NO];
	}
	[[self timeElapsedField] setText:str];
	if ([[[self currentCountdown] date] compare:today] == NSOrderedAscending) {
		[[self moveButton] setHidden:YES];
	}
}

+ (NSDateComponents *)lastIndexFromComps:(NSDateComponents *)comps withDelay:(int)delay {
	switch (delay) {
		case 86400:
            if ([comps hour] == 0 && [comps minute] == 0 && [comps second] == 0) {
                [comps setDay:[comps day]-1];
            }
			[comps setHour:0];
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 3600:
            if ([comps minute] == 0 && [comps second] == 0) {
                [comps setHour:[comps hour]-1];
            }
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 900:
            if ([comps minute]%15 == 0 && [comps second] == 0) {
                [comps setMinute:[comps minute]-15];
            }
			[comps setMinute:[comps minute]-[comps minute]%15];
			[comps setSecond:0];
			break;
		case 300:
            if ([comps minute]%5 == 0 && [comps second] == 0) {
                [comps setMinute:[comps minute]-5];
            }
			[comps setMinute:[comps minute]-[comps minute]%5];
			[comps setSecond:0];
			break;
	}
	return comps;
}

+ (NSDateComponents *)lastIndexFromCompsExclusive:(NSDateComponents *)comps withDelay:(int)delay {
	switch (delay) {
		case 86400:
			[comps setHour:0];
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 3600:
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 900:
			[comps setMinute:[comps minute]-[comps minute]%15];
			[comps setSecond:0];
			break;
		case 300:
			[comps setMinute:[comps minute]-[comps minute]%5];
			[comps setSecond:0];
			break;
	}
	return comps;
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	[self setSwitchTab:NO];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
	[[self timer] invalidate];
}

- (IBAction)loadCountupsView:(id)sender {
	[self performSegueWithIdentifier:@"loadCountupsView" sender:sender];
}

- (void)globalizeVariables {
	[Shared setCurrentTab:1-[self switchTab]];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setCountdowns:[Shared countups]];
	[self setCurrentCountdown:[Shared currentCountdown]];
	[self setTimesets:[Shared timesets]];
	// END RETRIEVAL
	[[[self navBar] topItem] setTitle:[[self currentCountdown] name]];
	if (![[[[self currentCountdown] timeset] self] invincible]) {
		[[self imageView] setImage:[UIImage imageNamed:@"bulletlist.png"]];
		UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTimeset:)];
		[tapped setNumberOfTapsRequired:1];
		[[self imageView] addGestureRecognizer:tapped];
		[[self imageView] setUserInteractionEnabled:YES];
	}
	[self updateUI];
	[self setTimer:[[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSince1970:(int)[realdate timeIntervalSince1970]+1] interval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES]];
	[[NSRunLoop currentRunLoop] addTimer:[self timer] forMode:NSDefaultRunLoopMode];
}

- (void)showTimeset:(UITapGestureRecognizer *)gesture {
	[[[iToast makeRealText:[NSString stringWithFormat:@"Active timeset:\n%@", [[[self currentCountdown] timeset] name]]] setDuration:2000] show];
}

@end
