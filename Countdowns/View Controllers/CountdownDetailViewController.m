#import "CountdownDetailViewController.h"

#import "CountdownDetailOptionsViewController.h"
#import "CountupDetailViewController.h"

@interface CountdownDetailViewController ()

@end

@implementation CountdownDetailViewController

- (IBAction)deleteButtonPressed:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete countdown?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)moveToCountups:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really move countdown?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Move" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)switchCountdown:(id)sender {
	if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Expand time elapsed"]) {
		[sender setTitle:@"Expand time remaining" forState:UIControlStateNormal];
	}
	else {
		[sender setTitle:@"Expand time elapsed" forState:UIControlStateNormal];
	}
	[self updateUI];
}

- (IBAction)editCountdownPressed:(id)sender {
	CountdownDetailOptionsViewController *target = [[self storyboard] instantiateViewControllerWithIdentifier:@"countdownDetailOptionsView"];
	[self presentViewController:target animated:YES completion:^{[target setSubviewController:self];}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
        [[self currentCountdown] kill];
		[[self countdowns] removeObject:[self currentCountdown]];
		[self loadCountdownsView:actionSheet];
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Move"]) {
        [[self currentCountdown] kill];
		[[self countdowns] removeObject:[self currentCountdown]];
		[[self currentCountdown] setIsCountdown:NO];
		[[self currentCountdown] setElapsed:nil];
		[[self currentCountdown] setupCountup];
		[[Shared countups] addObject:[self currentCountdown]];
		[self setSwitchTab:YES];
		[self loadCountdownsView:actionSheet];
	}
}

- (void)updateUI {
    [[self currentCountdown] updateCountdown];
	
	double firstHalf = 0;
	double secondHalf = 0;
	[[self moveButton] setHidden:YES];
	[[self imageView] setHidden:[[[[self currentCountdown] timeset] self] invincible]];
	
	if ([[[self currentCountdown] displayShort] isEqualToString:CDOWN_RECALC]) {
		[[self timeRemainingField] setText:[[self currentCountdown] displayLong]];
		[[self progressBar] setProgress:0];
		[[self percentageLabel] setText:@""];
		return;
	}
	
	double ratio = 0;
	
	NSDateComponents *diff2;
	firstHalf = round([[self currentCountdown] firstHalf]);
	
    NSMutableString *str = [NSMutableString stringWithString:@""];
    if ([[[self toggleSwitch] titleForState:UIControlStateNormal] isEqualToString:@"Expand time elapsed"]) {
        str = [NSMutableString stringWithString:[[[self currentCountdown] displayLong] copy]];
        if ([str isEqualToString:@"This countdown has expired."]) {
            [[self moveButton] setHidden:NO];
            ratio = 100;
        }
        else if ([str isEqualToString:@"The start date of this countdown\nhas not yet passed."]) {
            [[self moveButton] setHidden:YES];
            ratio = 0;
        }
        else {
            int n = (int)(7-([[str componentsSeparatedByString:@"\n"] count]-1-4));
            for (int i=0; i<n; i++) {
                [str appendString:@"\n"];
            }
            NSString *newstr = [[[self currentCountdown] elapsed] displayShort];
            if ([newstr isEqualToString:@"This countup has not yet started."]) {
                [str appendString:@"\nThis countup has not yet started."];
            }
            else {
                NSMutableString *substr = [NSMutableString stringWithString:@"Time elapsed since\n"];
                [substr appendFormat:@"%@", [Countdown stringForDate:[[[self currentCountdown] elapsed] date]]];
                [substr appendString:@":\n\n"];
                [str appendFormat:@"\n%@%@", substr, [newstr substringFromIndex:14]];
            }
            secondHalf = round([[self currentCountdown] secondHalf]);
            diff2 = [[[self currentCountdown] elapsed] displayComps];
        }
    }
    else {
        [str appendFormat:@"Time remaining until\n%@:\n\n", [Countdown stringForDate:[[self currentCountdown] date]]];
        if ([[[self currentCountdown] displayShort] rangeOfString:@"expired"].location == NSNotFound) {
            [str appendFormat:@"%@\n\n", [[[self currentCountdown] displayShort] substringFromIndex:16]];
            secondHalf = round([[self currentCountdown] secondHalf]);
            diff2 = [[[self currentCountdown] elapsed] displayComps];
            [str appendFormat:@"%@", [[[self currentCountdown] elapsed] displayLong]];
        }
        else {
            str = [NSMutableString stringWithString:@"This countdown has expired."];
            [[self moveButton] setHidden:NO];
            ratio = 100;
        }
    }
    [[self timeRemainingField] setText:str];
    
	if (ratio == 0) {
		if (firstHalf < 0 && secondHalf == 0) {
			ratio = 100;
		}
		else {
			ratio = 100-(firstHalf/(firstHalf+secondHalf) * 100);
		}
	}

	if (ratio <= 100) {
		if (ratio >= 0) {
			[[self progressBar] setProgress:ratio/100 animated:YES];
			[[self percentageLabel] setText:[NSString stringWithFormat:@"%i%%", (int)ratio]];
		}
		else {
			[[self progressBar] setProgress:0];
			[[self percentageLabel] setText:@""];
			// Fun but unprofessional.
//			[[self progressBar] setProgress:((double)arc4random())/ULONG_MAX animated:YES];
//			[[self percentageLabel] setText:@"????"];
		}
	}
	else {
		[[self progressBar] setProgress:1 animated:YES];
		[[self percentageLabel] setText:@"100%"];
	}
	
	if ([[[self currentCountdown] date] compare:today] == NSOrderedDescending) {
		[[self moveButton] setHidden:YES];
	}
}

+ (BOOL)testForBoundaryWithComps:(NSDateComponents *)comps andDelay:(int)delay { // Stealth method coming through!
	switch (delay) {
		case 86400:
			return ([comps hour] == 0 && [comps minute] == 0 && [comps second] == 0);
		case 3600:
			return ([comps minute] == 0 && [comps second] == 0);
		case 900:
			return ([comps minute]%15 == 0 && [comps second] == 0);
		case 300:
			return ([comps minute]%5 == 0 && [comps second] == 0);
		default:
			ERLog(@"[ERROR] Stealth method did not receive a valid delay!");
			return NO;
	}
}

+ (NSDateComponents *)nextIndexFromComps:(NSDateComponents *)comps withDelay:(int)delay {
	switch (delay) {
		case 86400:
			if (!([comps hour] == 0 && [comps minute] == 0 && [comps second] == 0) || true) {
				[comps setDay:[comps day]+1];
			}
			[comps setHour:0];
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 3600:
			if (!([comps minute] == 0 && [comps second] == 0) || true) {
				[comps setHour:[comps hour]+1];
			}
			[comps setMinute:0];
			[comps setSecond:0];
			break;
		case 900:
			if (!([comps minute]%15 == 0 && [comps second] == 0) || true) {
				[comps setMinute:[comps minute]+(15-[comps minute]%15)];
			}
			[comps setSecond:0];
			break;
		case 300:
			if (!([comps minute]%5 == 0 && [comps second] == 0) || true) {
				[comps setMinute:[comps minute]+(5-[comps minute]%5)];
			}
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

- (IBAction)loadCountdownsView:(id)sender {
	[self performSegueWithIdentifier:@"loadCountdownsView" sender:sender];
}

- (void)globalizeVariables {
	[Shared setCurrentTab:[self switchTab]];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setCountdowns:[Shared countdowns]];
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
#pragma mark GUAVA
}

- (void)showTimeset:(UITapGestureRecognizer *)gesture {
	[[[iToast makeRealText:[NSString stringWithFormat:@"Active timeset:\n%@", [[[self currentCountdown] timeset] name]]] setDuration:2000] show];
}

@end
