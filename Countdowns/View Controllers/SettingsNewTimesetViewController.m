#import "SettingsNewTimesetViewController.h"

#import "CountupDetailViewController.h"

@interface SettingsNewTimesetViewController ()

@end

@implementation SettingsNewTimesetViewController

- (IBAction)createTimeset:(id)sender {
	[[self currentTimeset] setName:[[self nameField] text]];
	[[self timesets] addObject:[self currentTimeset]];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:[[[self currentTimeset] constraints] count]] forKey:@"Timeset_Size"];
    [Flurry logEvent:@"Created_Timeset" withParameters:data];
	[self setCurrentTimeset:nil];
	[self loadSettingsTimesetsView:sender];
}

- (IBAction)clearTimeset:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really clear timeset?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
}

- (IBAction)copyButtonPressed:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Copy which timeset?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	for (int i=1; i<[[self timesets] count]; i++) {
		[actionSheet addButtonWithTitle:[[[self timesets] objectAtIndex:i] name]];
	}
	[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
	[actionSheet showInView:[self view]];
}

- (IBAction)nameChanged:(id)sender {
	if ([[sender text] isEqualToString:@"None"] || [[sender text] isEqualToString:@""]) {
		[[self createButton] setEnabled:NO];
        if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:NO];
	}
	else {
		[[self createButton] setEnabled:YES];
        if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:YES];
	}
	[[self currentTimeset] setName:[[self nameField] text]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[self currentTimeset] constraints] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tag = @"ConstraintCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
	}
	[[cell textLabel] setText:[[[[self currentTimeset] constraints] objectAtIndex:[indexPath row]] descriptor]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	int width = 195;
	NSString *description = [[[[self currentTimeset] constraints] objectAtIndex:[indexPath row]] descriptor];
	UIFont *font = [UIFont boldSystemFontOfSize:16];
	CGSize requiredSize = [description boundingRectWithSize:CGSizeMake(width, 9001) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
	return (int)(MAX(CELLSIZE, requiredSize.height+8));
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	int from = [sourceIndexPath row];
	int to = [destinationIndexPath row];
	if (from != to) {
		Constraint *constraint = [[[self currentTimeset] constraints] objectAtIndex:from];
		[[self currentTimeset] removeConstraintAtIndex:from];
		[[[self currentTimeset] constraints] insertObject:constraint atIndex:to];
		[[self currentTimeset] findDelay];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[self currentTimeset] removeConstraintAtIndex:[indexPath row]];
		[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:[indexPath row] inSection:[indexPath section]]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == [self nameField]) {
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == [self nameField]) {
		[self nameChanged:textField];
	}
	return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet title] isEqualToString:@"Really clear timeset?"]) {
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear"]) {
			[[self currentTimeset] setConstraints:[NSMutableArray new]];
			[[self currentTimeset] setName:@""];
			[[self nameField] setText:nil];
			[[self tableView] reloadData];
		}
	}
	if ([[actionSheet title] isEqualToString:@"Copy which timeset?"]) {
		if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
			buttonIndex += 1;
			Timeset *copiedTimeset = [[[self timesets] objectAtIndex:buttonIndex] copy];
			for (Constraint *constraint in [copiedTimeset constraints]) {
				[[self currentTimeset] addConstraint:constraint];
			}
			[[self nameField] setText:[[self currentTimeset] name]];
			[[self tableView] reloadData];
		}
	}
	if ([[actionSheet title] isEqualToString:@"Would you like to view the tutorial about timesets?"]) {
		[[self createButton] setEnabled:!([[[self nameField] text] isEqualToString:@"None"] || [[[self nameField] text] isEqualToString:@""])];
        if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:!([[[self nameField] text] isEqualToString:@"None"] || [[[self nameField] text] isEqualToString:@""])];
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
			[self performSegueWithIdentifier:@"loadTutorialView" sender:actionSheet];
		}
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"No, never prompt again"]) {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"If you would like to view the tutorial again, visit the settings page (the gear icon on the Countdowns and Countups screens) to revisit it." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
			[actionSheet showInView:[self view]];
		}
	}
	if ([[actionSheet title] isEqualToString:@"If you would like to view the tutorial again, visit the settings page (the gear icon on the Countdowns and Countups screens) to revisit it."]) {
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tutorial"];
		}
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Return to tutorial"]) {
		[self performSegueWithIdentifier:@"loadTutorialView" sender:actionSheet];
	}
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Finish"]) {
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	BOOL viewed = [Shared viewedTimeset] != nil;
	[[self createButton] setHidden:viewed];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (void)method {
	[[self createButton] setEnabled:!([[[self nameField] text] isEqualToString:@"None"] || [[[self nameField] text] isEqualToString:@""])];
    if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:!([[[self nameField] text] isEqualToString:@"None"] || [[[self nameField] text] isEqualToString:@""])];
}

- (IBAction)loadSettingsTimesetsView:(id)sender {
	if (![[Shared viewedTimeset] isEqual:[Shared originalTimeset]]) {
		// Do nothing. Again.
	}
	[self setDelayTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(actuallyDoTransition:) userInfo:nil repeats:NO]];
}

- (void)actuallyDoTransition:(id)sender {
	if ([[self currentTimeset] viewed]) {
		if (![[Shared viewedTimeset] isEqual:[Shared originalTimeset]]) {
            NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:[[[self currentTimeset] constraints] count]] forKey:@"Timeset_Size"];
            [Flurry logEvent:@"Edited_Timeset" withParameters:data];
				NSMutableArray *countdowns = [Shared countdowns];
			NSMutableArray *countups = [Shared countups];
			for (int i=0; i<[countdowns count]; i++) {
				Countdown *c = [countdowns objectAtIndex:i];
				if ([c timeset] == [Shared viewedTimeset]) {
					[c setTimeset:[self currentTimeset]];
					[[c elapsed] setTimeset:[self currentTimeset]];
					[c setupCountdown];
				}
			}
			for (int i=0; i<[countups count]; i++) {
				Countdown *c = [countups objectAtIndex:i];
				if ([c timeset] == [Shared viewedTimeset]) {
					[c setTimeset:[self currentTimeset]];
					[c setupCountup];
				}
			}
		}
		[Shared setViewedTimeset:[self currentTimeset]];
		[Shared setOriginalTimeset:nil];
		[self performSegueWithIdentifier:@"loadSettingsTimesetsViewHorizontal" sender:sender];
	}
	else {
		[self performSegueWithIdentifier:@"loadSettingsTimesetsViewVertical" sender:sender];
	}
}

- (IBAction)loadSettingsNewConstraintView:(id)sender {
	[self performSegueWithIdentifier:@"loadSettingsNewConstraintView" sender:sender];
}

- (void)globalizeVariables {
	if (![Shared viewedTimeset]) {
		[Shared setCurrentTimeset:[self currentTimeset]];
	}
	[Shared setCurrentTab:2];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(method) userInfo:nil repeats:NO];
	[Shared setSkipAppear:NO];
	[self setTimesets:[Shared timesets]];
	if ([Shared viewedTimeset]) {
		[self setCurrentTimeset:[Shared viewedTimeset]];
		[[self currentTimeset] setViewed:YES];
		if (![Shared originalTimeset]) {
			[Shared setOriginalTimeset:[[Shared viewedTimeset] copy]];
		}
	}
	else {
		[self setCurrentTimeset:[Shared currentTimeset]];
		[[self currentTimeset] setViewed:NO];
	}
	// END RETRIEVAL
	if (![self currentTimeset]) {
		[self setCurrentTimeset:[[Timeset alloc] init]];
	}
	[[self nameField] setText:[[self currentTimeset] name]];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"secondPrompt"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorial"]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"If you would like to view the tutorial again, visit the settings page (the gear icon on the Countdowns and Countups screens) to revisit it." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
		[actionSheet showInView:[self view]];
	}
	else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorial"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTutorial"]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to view the tutorial about timesets?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No",	nil];
		[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"No, never prompt again"]];
		[actionSheet showInView:[self view]];
	}
	else {
		if ([[[self nameField] text] isEqualToString:@""]) {
			[[self nameField] becomeFirstResponder];
			[[self createButton] setEnabled:NO];
            if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:NO];
		}
		else {
			[[self createButton] setEnabled:YES];
            if ([[self currentTimeset] viewed]) [[[[self navBar] topItem] leftBarButtonItem] setEnabled:YES];
		}
	}
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTutorial"];
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"secondPrompt"];
	[[self tableView] setEditing:YES animated:NO];
	[[[self navBar] topItem] setTitle:[[self currentTimeset] viewed] ? @"Edit Timeset" : @"New Timeset"];
	[[[[self navBar] topItem] leftBarButtonItem] setTitle:[[self currentTimeset] viewed] ? @"Done" : @"Cancel"];
	[[[[self navBar] topItem] leftBarButtonItem] setStyle:[[self currentTimeset] viewed] ? UIBarButtonItemStyleDone : UIBarButtonItemStyleBordered];
	[[self tableView] reloadData];
}

@end
