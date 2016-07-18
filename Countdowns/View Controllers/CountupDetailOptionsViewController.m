#import "CountupDetailOptionsViewController.h"

#import "CountupDetailViewController.h"

#define DATESTR @"Date"
#define TIMESTR @"Time"

@interface CountupDetailOptionsViewController ()

@end

@implementation CountupDetailOptionsViewController

// Partial credit to Matthias Bauch (you can tell because of the dot notation ;)
// http://stackoverflow.com/questions/4824043/uidatepicker-pop-up-after-uibutton-is-pressed

- (void)changeDate:(UIDatePicker *)sender {
	//
}

- (void)removeViews:(id)object {
	[[self.view viewWithTag:9] removeFromSuperview];
	[[self.view viewWithTag:10] removeFromSuperview];
	[[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
	CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
	CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
	[UIView beginAnimations:@"MoveOut" context:nil];
	[self.view viewWithTag:9].alpha = 0;
	[self.view viewWithTag:10].frame = datePickerTargetFrame;
	[self.view viewWithTag:11].frame = toolbarTargetFrame;
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeViews:)];
	[UIView commitAnimations];
	if ([[[self currentCountdown] date] compare:[NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:[[self datePickerPointer] date]]-[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:realdate] sinceDate:[[self datePickerPointer] date]]] != NSOrderedSame) {
		NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[[self datePickerPointer] date] toDate:today options:0];
		if ([comps year] <= 100 || [[[[self currentCountdown] timeset] self] invincible]) {
			[self finishDateSetting2];
		}
		else {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Timesets may not be applied to countdowns with more than 100 years elapsed since their start dates. Remove timeset from this countdown?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Timeset" otherButtonTitles:nil];
			[actionSheet showInView:[self view]];
		}
	}
}

- (void)finishDateSetting2 {
	[[self currentCountdown] setDate:[NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:[[self datePickerPointer] date]]-[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:realdate] sinceDate:[[self datePickerPointer] date]]];
    [self updateUI];
    [[self currentCountdown] setupCountup];
}

- (void)switchDatePickerFormat:(id)sender {
	if ([[[self barButtonPointer] titleForSegmentAtIndex:[[self barButtonPointer] selectedSegmentIndex]] isEqualToString:DATESTR]) {
		[[self datePickerPointer] setDatePickerMode:UIDatePickerModeDate];
	}
	else {
		[[self datePickerPointer] setDatePickerMode:UIDatePickerModeDateAndTime];
		NSDate *tempDate = [[self datePickerPointer] date];
		[[self datePickerPointer] setDate:[NSDate dateWithTimeIntervalSince1970:0]];
		[[self datePickerPointer] setDate:tempDate];
	}
}

- (IBAction)callDP:(id)sender {
	if ([self.view viewWithTag:9]) {
		return;
	}
	CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
	CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
	
	UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
	darkView.alpha = 0;
	darkView.backgroundColor = [UIColor blackColor];
	darkView.tag = 9;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
	[darkView addGestureRecognizer:tapGesture];
	[self.view addSubview:darkView];
	
	UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
	[datePicker setBackgroundColor:[UIColor whiteColor]];
	datePicker.tag = 10;
	[datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
	[datePicker setDate:[NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:realdate]-[[NSTimeZone systemTimeZone] daylightSavingTimeOffsetForDate:[[self currentCountdown] date]] sinceDate:[[self currentCountdown] date]]];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[self setDatePickerPointer:datePicker];
	[self.view addSubview:datePicker];
	
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
	toolBar.tag = 11;
	toolBar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
	UISegmentedControl *switchButton = [[UISegmentedControl alloc] initWithItems:@[DATESTR, TIMESTR]];
	[switchButton setSelectedSegmentIndex:0];
	[switchButton addTarget:self action:@selector(switchDatePickerFormat:) forControlEvents:UIControlEventValueChanged];
	[self setBarButtonPointer:switchButton];
	[toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:switchButton], spacer, doneButton, nil]];
	[self.view addSubview:toolBar];
	
	[UIView beginAnimations:@"MoveIn" context:nil];
	toolBar.frame = toolbarTargetFrame;
	datePicker.frame = datePickerTargetFrame;
	darkView.alpha = 0;
	[UIView commitAnimations];
}

// End credit

- (IBAction)switchTimeset:(id)sender {
	UIActionSheet *actionSheet;
	NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[[self currentCountdown] date] toDate:today options:0];
	if ([comps year] > 100) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Timesets may not be applied to countups with more than 100 years elapsed since their start dates." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
	}
	else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Use which timeset?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		for (int i=0; i<[[self timesets] count]; i++) {
			[actionSheet addButtonWithTitle:[(Timeset *)[[self timesets] objectAtIndex:i] name]];
		}
		[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
	}
	[actionSheet showInView:[self view]];
}

- (IBAction)switchUnits:(id)sender {
	NSMutableArray *units = [NSMutableArray arrayWithObjects:@"Year", @"Month", @"Week", @"Day", @"Hour", @"Minute", @"Second", nil];
	for (int i=0; i<[UNIT_DISPLAY count]; i++) {
		NSDateComponents *cucomps = [calendar components:[Countdown componentsForUnit:i] fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[calendar dateByAddingComponents:[[self currentCountdown] displayComps] toDate:[NSDate dateWithTimeIntervalSince1970:0] options:0] options:0];
		if (!cucomps || [Countdown componentFromComps:cucomps withUnit:i] == NSIntegerMax) {
			[units removeLastObject];
		}
	}
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Use which as the largest unit?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	for (int i=0; i<[units count]; i++) {
		[actionSheet addButtonWithTitle:[units objectAtIndex:i]];
	}
	[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
	[actionSheet showInView:[self view]];
}

- (IBAction)showUnitHelp:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Setting the largest unit lets you see the amount of time remaining in a countdown or countup in more specific units. If, for instance, the largest unit for a countdown is set to months, '1 year, 2 months' will become '14 months'; and if it is set to days it will become '426 days'. (This is a simplification and there would most likely be hours, minutes, and seconds as well.)" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)nameChanged:(id)sender {
	[[self currentCountdown] setName:[[self nameField] text]];
}

- (IBAction)loadCountdownDetailView:(id)sender {
	CountupDetailViewController *presenting = [self subviewController];
	[presenting viewWillAppear:YES];
	[Shared setSkipAppear:YES];
	[self dismissViewControllerAnimated:YES completion:^{[Shared setSkipAppear:NO];}];
}

- (void)updateUI {
    NSMutableString *str1 = [NSMutableString new];
    [str1 appendFormat:@"Start date: %@", [Countdown stringForDate:[[self currentCountdown] date]]];
    [[self targetDateField] setText:str1];
    
	[[self unitButton] setTitle:[NSString stringWithFormat:@"Largest unit: %@", [UNIT_DISPLAY objectAtIndex:[[self currentCountdown] unit]]] forState:UIControlStateNormal];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet title] isEqualToString:@"Use which timeset?"]) {
		if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
			Timeset *newTimeset = [[self timesets] objectAtIndex:buttonIndex];
			if ([[self currentCountdown] timeset] != newTimeset) {
				[[self currentCountdown] setTimeset:newTimeset];
                [self recalculateCountdown2];
			}
		}
	}
	else if ([[actionSheet title] isEqualToString:@"Use which as the largest unit?"]) {
		if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
			[[self currentCountdown] setUnit:6-buttonIndex];
			[[self unitButton] setTitle:[NSString stringWithFormat:@"Largest unit: %@", [UNIT_DISPLAY objectAtIndex:[[self currentCountdown] unit]]] forState:UIControlStateNormal];
		}
	}
	else if ([[actionSheet title] isEqualToString:@"Timesets may not be applied to countups with more than 100 years elapsed since their start dates. Remove timeset from this countdown?"]) {
		if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
			Timeset *none;
			for (int i=0; i<[[self timesets] count]; i++) {
				if ([[[[self timesets] objectAtIndex:i] self] invincible]) {
					none = [[self timesets] objectAtIndex:i];
				}
			}
			[[self currentCountdown] setTimeset:none];
			[self finishDateSetting2];
			[[self timesetButton] setTitle:[NSString stringWithFormat:@"Timeset: %@", [[[self currentCountdown] timeset] name]] forState:UIControlStateNormal];
		}
	}
}

- (void)recalculateCountdown2 {
	[[self currentCountdown] setupCountup];
	[[self timesetButton] setTitle:[NSString stringWithFormat:@"Timeset: %@", [[[self currentCountdown] timeset] name]] forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[[self backButton] setEnabled:[[[self nameField] text] length] > 0];
	if (textField == [self nameField]) {
		[textField resignFirstResponder];
	}
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (void)globalizeVariables {
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
    [Flurry logEvent:@"Viewed_Edit_Countup"];
	[self setCurrentCountdown:[Shared currentCountdown]];
	[self setTimesets:[Shared timesets]];
	[Shared setSkipAppear:NO];
	// END RETRIEVAL
	[[self timesetButton] setTitle:[NSString stringWithFormat:@"Timeset: %@", [[[self currentCountdown] timeset] name]] forState:UIControlStateNormal];
	[[self unitButton] setTitle:[NSString stringWithFormat:@"Largest unit: %@", [UNIT_DISPLAY objectAtIndex:[[self currentCountdown] unit]]] forState:UIControlStateNormal];
	[[self nameField] setText:[[self currentCountdown] name]];
	[self updateUI];
	[self setTimer:[[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSince1970:(int)[realdate timeIntervalSince1970]+1] interval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES]];
}

@end
