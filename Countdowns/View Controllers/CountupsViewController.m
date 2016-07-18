#import "CountupsViewController.h"

#import "CountupDetailViewController.h"
#import "SettingsViewController.h"

@interface CountupsViewController ()

@end

@implementation CountupsViewController

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
		[[cell accessoryView] addGestureRecognizer:tapped];
		[[cell accessoryView] setUserInteractionEnabled:YES];
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
	[self performSegueWithIdentifier:@"loadCountupDetailView" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)updateUI {
	for (NSIndexPath *path in [[self tableView] indexPathsForVisibleRows]) {
		if ([[self countdowns] count] > [path row]) {
			Countdown *countdown = [[self countdowns] objectAtIndex:[path row]];
            [countdown updateCountup];
		}
	}
	[[self tableView] reloadData];
	[[self emptyLabel] setText:@"You have no countups.\nAdd one with the + button."];
	[[self emptyLabel] setHidden:[[self countdowns] count] > 0];
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
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
		[[segue destinationViewController] setDelegateController2:self];
	}
}

- (IBAction)loadNewCountupView:(id)sender {
	[self performSegueWithIdentifier:@"loadNewCountupView" sender:sender];
}

- (void)globalizeVariables {
	[Shared setCurrentCountdown:[self currentCountdown]];
	[Shared setFromCountdowns:NO];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setCountdowns:[Shared countups]];
	[self setTimesets:[Shared timesets]];
	// END RETRIEVAL
	if ([self countdowns] == nil) {
		[self setCountdowns:[NSMutableArray new]];
	}
	[self setCountdowns:[NSMutableArray arrayWithArray:[[self countdowns] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]]]];
	[self updateUI];
	for (Countdown *countdown in [self countdowns]) {
		[countdown updateCountup];
	}
	[self setTimer:[[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSince1970:(int)[realdate timeIntervalSince1970]+1] interval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES]];
	[[NSRunLoop currentRunLoop] addTimer:[self timer] forMode:NSDefaultRunLoopMode];
	[[self navBar] setBounds:CGRectMake(0, 0, 320, 44)];
	[[self navBar] setFrame:CGRectMake(0, 20, 320, 44)];
	[[self tableView] setContentOffset:CGPointZero];
	[[self tableView] setContentInset:UIEdgeInsetsZero];
}

@end
