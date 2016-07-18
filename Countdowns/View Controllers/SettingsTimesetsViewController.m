#import "SettingsTimesetsViewController.h"

@interface SettingsTimesetsViewController ()

@end

@implementation SettingsTimesetsViewController

- (IBAction)editButtonClicked:(id)sender {
	if ([[sender title] isEqualToString:@"Edit List"]) {
		[sender setTitle:@"Done"];
		[(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleDone];
		[[self tableView] setEditing:YES animated:YES];
	}
	else if ([[sender title] isEqualToString:@"Done"]) {
		[sender setTitle:@"Edit List"];
		[(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleBordered];
		[[self tableView] setEditing:NO animated:YES];
	}
}

- (IBAction)addButtonClicked:(id)sender {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorial"]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTutorial"];
	}
	[self performSegueWithIdentifier:@"loadSettingsNewTimesetViewVertical" sender:sender];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self timesets] count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
	NSString *tag = @"TimesetCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
	}
	[[cell textLabel] setText:[(Timeset *)[[self timesets] objectAtIndex:[indexPath row]] name]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELLSIZE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
	if ([[[self timesets] objectAtIndex:[indexPath row]] invincible]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You may not edit the None timeset." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
		[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	[self setViewedTimeset:[[self timesets] objectAtIndex:[indexPath row]]];
	[self loadSettingsNewTimesetView:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	sourceIndexPath = [NSIndexPath indexPathForRow:[sourceIndexPath row]+1 inSection:[sourceIndexPath section]];
	destinationIndexPath = [NSIndexPath indexPathForRow:[destinationIndexPath row]+1 inSection:[destinationIndexPath section]];
	int from = [sourceIndexPath row];
	int to = [destinationIndexPath row];
	if (from != to) {
		Timeset *timeset = [[self timesets] objectAtIndex:from];
		[[self timesets] removeObjectAtIndex:from];
		[[self timesets] insertObject:timeset atIndex:to];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (![[[self timesets] objectAtIndex:[indexPath row]] invincible]) {
			[self setCurrentIndex:[indexPath row]];
			BOOL timesetUsed = NO;
			for (int i=0; i<[[self countdowns] count]; i++) {
				if ([[[self countdowns] objectAtIndex:i] timeset] == [[self timesets] objectAtIndex:[self currentIndex]]) {
					timesetUsed = YES;
				}
			}
			for (int i=0; i<[[self countups] count]; i++) {
				if ([[[self countups] objectAtIndex:i] timeset] == [[self timesets] objectAtIndex:[self currentIndex]]) {
					timesetUsed = YES;
				}
			}
			UIActionSheet *actionSheet;
			if (timesetUsed) {
				actionSheet = [[UIActionSheet alloc] initWithTitle:@"This timeset is being used by one or more countdowns or countups. Really delete it?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
			}
			else {
				actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete timeset?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
			}
			[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
		}
		else {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You may not delete the None timeset." delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
			[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]) {
		Timeset *none;
		for (int i=0; i<[[self timesets] count]; i++) {
			if ([[[[self timesets] objectAtIndex:i] self] invincible]) {
				none = [[self timesets] objectAtIndex:i];
                break;
			}
		}
		for (int i=0; i<[[self countdowns] count]; i++) {
			if ([[[self countdowns] objectAtIndex:i] timeset] == [[self timesets] objectAtIndex:[self currentIndex]]) {
				[[[self countdowns] objectAtIndex:i] setTimeset:none];
				[[[[self countdowns] objectAtIndex:i] elapsed] setTimeset:none];
                [[[self countdowns] objectAtIndex:i] setupCountdown];
			}
		}
		for (int i=0; i<[[self countups] count]; i++) {
			if ([[[self countups] objectAtIndex:i] timeset] == [[self timesets] objectAtIndex:[self currentIndex]]) {
				[[[self countups] objectAtIndex:i] setTimeset:none];
                [[[self countups] objectAtIndex:i] setupCountup];
			}
		}
		[[self timesets] removeObjectAtIndex:[self currentIndex]];
		[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:[self currentIndex]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	[[self emptyLabel] setHidden:[[self timesets] count] > 1];
}

- (void)loadSettingsView:(id)sender {
	[self performSegueWithIdentifier:@"loadSettingsView" sender:sender];
}

- (void)loadSettingsNewTimesetView:(id)sender {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorial"]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTutorial"];
	}
	[self performSegueWithIdentifier:@"loadSettingsNewTimesetViewHorizontal" sender:sender];
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[[segue destinationViewController] setHidesBottomBarWhenPushed:YES];
	CGRect frame = [[self tableView] frame];
	[[self tableView] setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+[[[self tabBarController] tabBar] frame].size.height)];
}

- (void)hideTabBar {
	return;
	BOOL hiddenTabBar = NO;
	UITabBarController *tabBarController = [self tabBarController];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	for(UIView *view in tabBarController.view.subviews)
	{
		CGRect _rect = view.frame;
		if([view isKindOfClass:[UITabBar class]])
		{
			if (hiddenTabBar) {
				_rect.origin.y = 431;
				[view setFrame:_rect];
			} else {
				_rect.origin.y = 480;
				[view setFrame:_rect];
			}
		} else {
			if (hiddenTabBar) {
				_rect.size.height = 431;
				[view setFrame:_rect];
			} else {
				_rect.size.height = 480;
				[view setFrame:_rect];
			}
		}
	}
	[UIView commitAnimations];
	
	hiddenTabBar = !hiddenTabBar;
}

- (void)globalizeVariables {
	[Shared setViewedTimeset:[self viewedTimeset]];
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	[self setTimesets:[Shared timesets]];
	[Shared setViewedTimeset:nil];
	[self setCountdowns:[Shared countdowns]];
	[self setCountups:[Shared countups]];
	// END RETRIEVAL
	[[self tableView] reloadData];
	[[self emptyLabel] setText:@"You have no timesets.\nAdd one with the + button."];
	[[self emptyLabel] setHidden:[[self timesets] count] > 1];
	[[self tableView] setContentOffset:CGPointZero];
	[[self tableView] setContentInset:UIEdgeInsetsZero];
}

@end
