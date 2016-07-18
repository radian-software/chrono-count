// Guava. Do not modify.

#import "CountdownsViewController.h"

#import "CountdownDetailViewController.h"
#import "SettingsViewController.h"

@interface CountdownsViewController ()

@end

@implementation CountdownsViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self countdowns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tag = @"CountdownCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tag];
	}
	[[cell textLabel] setText:[[[self countdowns] objectAtIndex:[indexPath row]] name]];
	[[cell detailTextLabel] setText:[[[self countdowns] objectAtIndex:[indexPath row]] displayShort]];
	[cell setOpaque:YES];
	if (![[[[[self countdowns] objectAtIndex:[indexPath row]] timeset] self] invincible]) {
		UIImageView *view = [[UIImageView alloc] initWithImage:[Shared bulletlist]];
		[view setOpaque:YES];
		[cell setAccessoryView:view];
		UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTimeset:)];
		[tapped setNumberOfTapsRequired:1];
		
		UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake([view frame].origin.x + 268, [view frame].origin.y, [view frame].size.width + 14, [view frame].size.height + 14)];
		
		[tapView addGestureRecognizer:tapped];
		[tapView setUserInteractionEnabled:YES];
		[cell addSubview:tapView];
		[[cell accessoryView] setUserInteractionEnabled:NO];
	}
    else {
        [cell setAccessoryView:nil];
    }
	return cell;
}

- (void)showTimeset:(UITapGestureRecognizer *)gesture {
	UITableViewCell *cell = (UITableViewCell *)[[gesture view] ancestorViewOfType:[UITableViewCell class]];
	int i = [[[self tableView] indexPathForCell:cell] row];
	[[[iToast makeRealText:[NSString stringWithFormat:@"Active timeset:\n%@", [[[[self countdowns] objectAtIndex:i] timeset] name]]] setDuration:2000] show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELLSIZE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setCurrentCountdown:[[self countdowns] objectAtIndex:[indexPath row]]];
	[self performSegueWithIdentifier:@"loadCountdownDetailView" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)updateUI {
	for (int i=0; i<[self tableView:[self tableView] numberOfRowsInSection:0]; i++) {
		__unused UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		// Do nothing.
	}
	for (NSIndexPath *path in [[self tableView] indexPathsForVisibleRows]) {
		if ([[self countdowns] count] >= [path row]+1) {
			Countdown *countdown = [[self countdowns] objectAtIndex:[path row]];
            [countdown updateCountdown];
		}
	}
	[[self emptyLabel] setText:@"You have no countdowns.\nAdd one with the + button."];
	[[self emptyLabel] setHidden:[[self countdowns] count] > 0];
    [[self tableView] performSelector:@selector(reloadData) withObject:nil afterDelay:TABLEDELAY]; // *warning warning warning*
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	[[[self view] layer] setDrawsAsynchronously:YES];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
	[[self timer] invalidate];
}

- (void)viewDidLayoutSubviews {
	[[self navBar] setBounds:CGRectMake(0, 0, 320, 44)];
	[[self navBar] setFrame:CGRectMake(0, 20, 320, 44)];
	[[self settingsButton] setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:24], NSFontAttributeName, nil] forState:UIControlStateNormal];
	[[self view] layoutSubviews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[[segue destinationViewController] setHidesBottomBarWhenPushed:YES];
	if ([[segue identifier] isEqualToString:@"loadSettingsView"]) {
		[[segue destinationViewController] setDelegateController:self];
	}
}

- (IBAction)loadNewCountdownView:(id)sender {
	[self performSegueWithIdentifier:@"loadNewCountdownView" sender:sender];
}

- (void)globalizeVariables {
	[Shared setCurrentCountdown:[self currentCountdown]];
	[Shared setFromCountdowns:YES];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setCountdowns:[Shared countdowns]];
	[self setTimesets:[Shared timesets]];
	// END RETRIEVAL
	if ([self timesets] == nil) {
		Timeset *none = [[Timeset alloc] initWithName:@"None"];
		[none setInvincible:YES];
		[self setTimesets:[NSMutableArray arrayWithObject:none]];
	}
	[self setCountdowns:[NSMutableArray arrayWithArray:[[self countdowns] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]]]]];
	[self updateUI];
	for (Countdown *countdown in [self countdowns]) {
		[countdown updateCountdown];
	}
	[self setTimer:[[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSince1970:(int)[realdate timeIntervalSince1970]+1] interval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES]];
	[[NSRunLoop currentRunLoop] addTimer:[self timer] forMode:NSDefaultRunLoopMode];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"welcome"]) {
		[self performSegueWithIdentifier:@"welcome" sender:self];
	}
	[[self navBar] setBounds:CGRectMake(0, 0, 320, 44)];
	[[self navBar] setFrame:CGRectMake(0, 20, 320, 44)];
	[[self tableView] setContentOffset:CGPointZero];
	[[self tableView] setContentInset:UIEdgeInsetsZero];
}

@end
