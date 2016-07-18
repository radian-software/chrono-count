#import "NewCountdownViewController.h"

@interface NewCountdownViewController ()

@end

@implementation NewCountdownViewController

- (IBAction)switchDatePicker:(id)sender {
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[[self datePicker] setDatePickerMode:UIDatePickerModeDate];
			break;
		case 1: {
			[[self datePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
			NSDate *tempDate = [[self datePicker] date];
			[[self datePicker] setDate:[NSDate dateWithTimeIntervalSince1970:0]];
			[[self datePicker] setDate:tempDate];
			break;
		}
		default:
			ERLog(@"[WARNING] Unable to set date picker mode.");
			break;
	}
}

- (IBAction)createCountdown:(id)sender {
	[[self countdowns] addObject:[[Countdown alloc] initWithName:[[self nameField] text] date:[NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:[[self datePicker] date]]-[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:nowdate] sinceDate:[[self datePicker] date]] timeset:[self currentTimeset]]];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[[[[self countdowns] lastObject] date] timeIntervalSinceDate:realdate]], @"Countdown_Length", [NSNumber numberWithBool:![[[[self countdowns] lastObject] timeset] invincible]], @"Using_Timeset", nil];
    [Flurry logEvent:@"Created_Countdown" withParameters:data];
	[self loadCountdownsView:sender];
}

- (IBAction)switchTimeset:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Use which timeset?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	for (int i=0; i<[[self timesets] count]; i++) {
		[actionSheet addButtonWithTitle:[(Timeset *)[[self timesets] objectAtIndex:i] name]];
	}
	[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
	[actionSheet showInView:[self view]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == [self nameField]) {
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == [self nameField]) {
		[[self createButton] setEnabled:!([[textField text] length] == 1 && range.location == 0)];
	}
	return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
		[self setCurrentTimeset:[[self timesets] objectAtIndex:buttonIndex]];
		[[self timesetButton] setTitle:[NSString stringWithFormat:@"Timeset: %@", [[self currentTimeset] name]] forState:UIControlStateNormal];
		if ([[[self currentTimeset] self] invincible]) {
			[[self datePicker] setMaximumDate:nil];
		}
		else {
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:100];
			[[self datePicker] setMaximumDate:[calendar dateByAddingComponents:comps toDate:today options:0]];
			if ([[[self datePicker] date] compare:[[self datePicker] maximumDate]] == NSOrderedDescending) {
				[[self datePicker] setDate:[[self datePicker] maximumDate] animated:YES];
			}
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
    [self setDatePicker:[Shared datePicker]];
    [[self datePicker] setFrame:CGRectMake(0, 118, 320, 216)];
    [[self datePicker] setDatePickerMode:UIDatePickerModeDate];
    [[self datePicker] setDate:nowdate];
    [[self view] addSubview:[self datePicker]];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (IBAction)loadCountdownsView:(id)sender {
	[self performSegueWithIdentifier:@"loadCountdownsView" sender:sender];
}

- (void)globalizeVariables {
	[Shared setCurrentTab:0];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[Shared setSkipAppear:NO];
	[self setCountdowns:[Shared countdowns]];
	[self setTimesets:[Shared timesets]];
	// END RETRIEVAL
	[[self nameField] becomeFirstResponder];
	Timeset *none;
	for (int i=0; i<[[self timesets] count]; i++) {
		if ([[[[self timesets] objectAtIndex:i] self] invincible]) {
			none = [[self timesets] objectAtIndex:i];
		}
	}
	[self setCurrentTimeset:none];
	[[self timesetButton] setTitle:[NSString stringWithFormat:@"Timeset: %@", [[self currentTimeset] name]] forState:UIControlStateNormal];
	NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[[self datePicker] date]];
	if ([comps second] != 0 || [comps minute] != 0) {
		[comps setHour:[comps hour]+1];
	}
	[comps setSecond:0];
	[[self datePicker] setDate:[calendar dateFromComponents:comps]];
}

@end
