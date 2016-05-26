//
//  SettingsNewConstraintViewController.m
//  Countdowns
//
//  Created by raxod502 on 6/4/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "SettingsNewConstraintViewController.h"

#import "IntegerDictionary.h"
#import "IntegerArray.h"

@interface SettingsNewConstraintViewController ()

@end

@implementation SettingsNewConstraintViewController

- (void)makeDescription {
	if ([[[[self currentConstraint] qualifiers] objectAtIndex:3] group] == RANGE_OF_DAYS_IN_YEAR && ([[[[self currentConstraint] qualifiers] objectAtIndex:1] group] != NONE || [[[[self currentConstraint] qualifiers] objectAtIndex:2] group] != NONE)) {
		[[self descView] setText:@"If 'Range of days in year' is selected, Months and Holidays qualifiers are not allowed. Please remove one or the other."];
		[[self addButton] setEnabled:NO];
	}
	else if ([[[[self currentConstraint] qualifiers] objectAtIndex:3] group] == SPECIFIC_DAY_IN_YEAR && ([[[[self currentConstraint] qualifiers] objectAtIndex:1] group] != NONE || [[[[self currentConstraint] qualifiers] objectAtIndex:2] group] != NONE)) {
		[[self descView] setText:@"If 'Specific day in year' is selected, Months and Holidays qualifiers are not allowed. Please remove one or the other."];
		[[self addButton] setEnabled:NO];
	}
	else if ([[[[self currentConstraint] qualifiers] objectAtIndex:2] group] != NONE && ([[[[self currentConstraint] qualifiers] objectAtIndex:1] group] != NONE || [[[[self currentConstraint] qualifiers] objectAtIndex:3] group] != NONE || [[[[self currentConstraint] qualifiers] objectAtIndex:4] group] != NONE)) {
		[[self descView] setText:@"If 'Specific holiday' is selected, Months, Days, and Weekdays qualifiers are not allowed. Please remove one or the other."];
		[[self addButton] setEnabled:NO];
	}
	else {
		[[self descView] setText:[[self currentConstraint] descriptorForState:[[self excludeIncludeSwitch] titleForSegmentAtIndex:[[self excludeIncludeSwitch] selectedSegmentIndex]]]];
		[[self addButton] setEnabled:YES];
	}
}

- (int)findSumOfBools:(BOOL)firstArg, ... {
    ERLog(@"[ERROR] findSumOfBools: is non-functional. DO NOT use it.");
    return -51;
	va_list args;
	int sum = !!firstArg;
	va_start(args, firstArg);
	BOOL object;
//	while ((object = va_arg(args, int)) != END) {
		sum += !!object;
//	}
	return sum;
}

- (BOOL)checkForQuota:(int)quota inBools:(BOOL)firstArg, ... {
    ERLog(@"[ERROR] checkForQuota:: is non-functional. DO NOT use it.");
    return -51;
	va_list args;
	int sum = !!firstArg;
	va_start(args, firstArg);
	BOOL object;
//	while ((object = va_arg(args, int)) != END) {
		sum += !!object;
//	}
	return sum >= quota;
}

- (IBAction)loadSettingsNewTimesetView:(id)sender {
	[self performSegueWithIdentifier:@"loadSettingsNewTimesetView" sender:sender];
}

- (IBAction)addConstraint:(id)sender {
	[[self currentConstraint] setState:[[self excludeIncludeSwitch] titleForSegmentAtIndex:[[self excludeIncludeSwitch] selectedSegmentIndex]]];
	[[self currentTimeset] addConstraint:[self currentConstraint]];
	[self loadSettingsNewTimesetView:sender];
}

- (IBAction)excludeIncludeChanged:(id)sender {
	[self makeDescription];
}

- (void)viewWillAppear:(BOOL)animated {
	[[self view] setMultipleTouchEnabled:NO];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(retrieveVariables) userInfo:nil repeats:NO]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self globalizeVariables];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[self setTableView:[[segue destinationViewController] tableView]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"There is another qualifier active in the same category. It will be disabled to make room for this one." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Replace" otherButtonTitles:nil];
	[self setTableView:tableView];
	[self setLastCell:indexPath];
	BOOL morethings = NO;
	NSArray *indices = [tableView indexPathsForSelectedRows];
	for (int i=0; i<[indices count]; i++) {
		if ([[indices objectAtIndex:i] section] == [indexPath section] && [[indices objectAtIndex:i] row] != [indexPath row]) {
			morethings = YES;
		}
	}
	if (morethings) {
		[actionSheet showInView:[self view]];
	}
	else {
		[self actionSheet:actionSheet clickedButtonAtIndex:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self currentConstraint] addQualifier:[[Qualifier alloc] init] atIndex:[indexPath section]];
	[[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] setText:@" "];
	[self makeDescription];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIActionSheet *newActionSheet;
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Replace"]) {
		[[self currentConstraint] addQualifier:[[Qualifier alloc] initWithGroup:NONE] atIndex:[[self lastCell] section]];
		[self makeDescription];
		[self setQualifierProgress:[[Qualifier alloc] initWithGroup:[[self lastCell] row]]];
		for (int row=0; row<[[self tableView] numberOfRowsInSection:[[self lastCell] section]]; row++) {
			if ([[self lastCell] row] != row) {
				[[self tableView] deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:[[self lastCell] section]] animated:YES];
			}
		}
		switch ([[self lastCell] section]*10+[[self lastCell] row]) {
			case 00: {
                int year = [[calendar components:NSYearCalendarUnit fromDate:realdate] year];
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a year from the past or future?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Past", [NSString stringWithFormat:@"%i", year], @"Future", nil];
				break;
            }
			case 01: {
                int year = [[calendar components:NSYearCalendarUnit fromDate:realdate] year];
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a starting year from the past or future?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Past", [NSString stringWithFormat:@"%i", year], @"Future", nil];
				break;
            }
			case 10:
			case 30:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a month." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
				break;
			case 11:
			case 32:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a starting month." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
				break;
			case 20:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a holiday." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
				for (int i=0; i<[[self holidays] count]; i++) {
					[newActionSheet addButtonWithTitle:[[[self holidays] objectAtIndex:i] name]];
				}
				[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
				break;
			case 31:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day in the month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
				for (int i=1; i<32; i++) {
					[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
				}
				[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
				break;
			case 33:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a starting day in the month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
				for (int i=1; i<32; i++) {
					[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
				}
				[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
				break;
			case 40:
			case 43:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day of the week." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
				break;
			case 41:
			case 42:
				[self setQualifierProgress:[[Qualifier alloc] initWithGroup:[[self lastCell] row]]];
				[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
				[self makeDescription];
				break;
			case 44:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day of the week." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
				break;
			case 50:
				newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a starting hour." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
				[newActionSheet addButtonWithTitle:@"12 AM"];
				for (int i=1; i<12; i++) {
					[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i AM", i]];
				}
				[newActionSheet addButtonWithTitle:@"Noon"];
				for (int i=1; i<12; i++) {
					[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i PM", i]];
				}
				[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
			default:
				break;
		}
	}
	else {
		int currentYear;
		switch ([[self lastCell] section]*10+[[self lastCell] row]) {
			case 00:
				if ([[actionSheet title] isEqualToString:@"Select a year from the past or future?"]) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a year." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
						currentYear = [[calendar components:NSYearCalendarUnit fromDate:today] year];
						if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Past"]) {
							for (int i=currentYear; i>currentYear-100; i--) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
                        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Future"]) {
							for (int i=currentYear; i<currentYear+100; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
                        }
						else {
                            newActionSheet = nil;
                            [[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
                            [[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
                            [self makeDescription];
						}
						break;
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 01:
				if ([[actionSheet title] isEqualToString:@"Select a starting year from the past or future?"]) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a starting year." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
						currentYear = [[calendar components:NSYearCalendarUnit fromDate:today] year];
						if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Past"]) {
							for (int i=currentYear; i>currentYear-100; i--) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
                        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Future"]) {
							for (int i=currentYear; i<currentYear+100; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
                        else {
                            [[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
                            newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an ending year from the past or future?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Past", [NSString stringWithFormat:@"%i", currentYear], @"Future", nil];
                        }
						break;
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else if ([[actionSheet title] isEqualToString:@"Please select a starting year."]) {
                    currentYear = [[calendar components:NSYearCalendarUnit fromDate:today] year];
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an ending year from the past or future?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Past", [NSString stringWithFormat:@"%i", currentYear], @"Future", nil];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else if ([[actionSheet title] isEqualToString:@"Select an ending year from the past or future?"]) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending year." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
						currentYear = [[calendar components:NSYearCalendarUnit fromDate:today] year];
						if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Past"]) {
							for (int i=currentYear; i>currentYear-100; i--) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Future"]) {
							for (int i=currentYear; i<currentYear+100; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
                        else {
                            newActionSheet = nil;
                            [[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
                            [[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
                            [self makeDescription];
                        }
						break;
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 10:
			case 20:
			case 21:
			case 40:
				if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
					[[[self qualifierProgress] datums] addInteger:buttonIndex];
					[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
					[self makeDescription];
				}
				else {
					[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
				}
				break;
			case 11:
				if ([[[self qualifierProgress] datums] count] == 0) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending month." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 30:
				if ([[[self qualifierProgress] datums] count] == 0) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day in the month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
						for (int i=1; i<32; i++) {
							[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
						}
						[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 31:
				if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
					[[[self qualifierProgress] datums] addInteger:buttonIndex];
					[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
					[self makeDescription];
				}
				else {
					[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
				}
				break;
			case 32:
				switch ([[[self qualifierProgress] datums] count]) {
					case 0:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day in the starting month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							for (int i=1; i<32; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 1:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending month." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 2:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a day in the ending month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							for (int i=1; i<32; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 3:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
							[self makeDescription];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					default:
						break;
				}
				break;
			case 33:
				if ([[[self qualifierProgress] datums] count] == 0) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending day in the month." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
						for (int i=1; i<32; i++) {
							[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
						}
						[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 43:
				if ([[[self qualifierProgress] datums] count] == 0) {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a specific day." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"First", @"Second", @"Third", @"Fourth", @"Fifth", @"Last", nil];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				else {
					if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
						[[[self qualifierProgress] datums] addInteger:buttonIndex];
						[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
						[self makeDescription];
					}
					else {
						[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
					}
				}
				break;
			case 44:
				if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
					NSArray *days = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
					NSArray *months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];					switch ([[[self qualifierProgress] datums] count]) {
						case 0: {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"You will now choose the first %@ to be specified. Please select a year.", [days objectAtIndex:buttonIndex]] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							int year = [[calendar components:NSYearCalendarUnit fromDate:today] year];
							for (int i=year-10; i<year+10; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
							break;
						}
						case 1:
							[[[self qualifierProgress] datums] addInteger:[[actionSheet buttonTitleAtIndex:buttonIndex] integerValue]];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select a month." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
							break;
						case 2: {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Please select the first %@ to be specified.", [days objectAtIndex:[[[self qualifierProgress] datums] integerAtIndex:0]]] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							NSDateComponents *comps = [[NSDateComponents alloc] init];
							[comps setYear:[[[self qualifierProgress] datums] integerAtIndex:1]];
							[comps setMonth:[[[self qualifierProgress] datums] integerAtIndex:2]+1];
							[comps setDay:1];
							comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:comps]];
							[comps setDay:[comps day] - ([comps weekday] - ([[[self qualifierProgress] datums] integerAtIndex:0]+1))];
							comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:comps]];
							if ([comps month] != [[[self qualifierProgress] datums] integerAtIndex:2]+1) {
								[comps setDay:[comps day]+7];
							}
							NSDate *date = [calendar dateFromComponents:comps];
							IntegerArray *daylist = [IntegerArray new];
							while (true) {
								[daylist addInteger:[[calendar components:NSDayCalendarUnit fromDate:date] day]];
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ %i, %i", [months objectAtIndex:[[[self qualifierProgress] datums] integerAtIndex:2]], [[calendar components:NSDayCalendarUnit fromDate:date] day], [[[self qualifierProgress] datums] integerAtIndex:1]]];
								date = [NSDate dateWithTimeInterval:7*24*3600 sinceDate:date];
								if ([[calendar components:NSMonthCalendarUnit fromDate:date] month] != [[[self qualifierProgress] datums] integerAtIndex:2]+1) break;
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
							[self setTempList:daylist];
							break;
						}
						case 3: {
							IntegerArray *daylist = [self tempList];
							[[[self qualifierProgress] datums] addInteger:[daylist integerAtIndex:buttonIndex]-1];
							int year = [[[self qualifierProgress] datums] integerAtIndex:1];
							int month = [[[self qualifierProgress] datums] integerAtIndex:2];
							int day = [[[self qualifierProgress] datums] integerAtIndex:3];
							[[[self qualifierProgress] datums] setInteger:month atIndexedSubscript:1];
							[[[self qualifierProgress] datums] setInteger:day atIndexedSubscript:2];
							[[[self qualifierProgress] datums] setInteger:year atIndexedSubscript:3];
							[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
							[self makeDescription];
						}
						default:
							break;
					}
				}
				else {
					[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
				}
				break;
			case 50:
				switch ([[[self qualifierProgress] datums] count]) {
					case 0:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an starting minute." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							for (int i=0; i<60; i+=5) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@":%.2i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 1:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending hour." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							[newActionSheet addButtonWithTitle:@"12 AM"];
							for (int i=1; i<12; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i AM", i]];
							}
							[newActionSheet addButtonWithTitle:@"Noon"];
							for (int i=1; i<12; i++) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@"%i PM", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 2:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							newActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select an ending minute." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
							for (int i=0; i<60; i+=5) {
								[newActionSheet addButtonWithTitle:[NSString stringWithFormat:@":%.2i", i]];
							}
							[newActionSheet setCancelButtonIndex:[newActionSheet addButtonWithTitle:@"Cancel"]];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					case 3:
						if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
							[[[self qualifierProgress] datums] addInteger:buttonIndex];
							[[self currentConstraint] addQualifier:[self qualifierProgress] atIndex:[[self lastCell] section]];
							[self makeDescription];
						}
						else {
							[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
						}
						break;
					default:
						break;
				}
				break;
			default:
				if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
					[[self tableView] deselectRowAtIndexPath:[self lastCell] animated:YES];
				}
				break;
		}
	}
	if (newActionSheet) {
		[newActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
		[newActionSheet showInView:[self view]];
	}
}

- (void)globalizeVariables {
	if ([[self currentTimeset] viewed]) {
		[Shared setViewedTimeset:[self currentTimeset]];
	}
	else {
		[Shared setCurrentTimeset:[self currentTimeset]];
	}
	[[[UIApplication sharedApplication] delegate] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)retrieveVariables {
	if ([Shared viewedTimeset]) {
		[self setCurrentTimeset:[Shared viewedTimeset]];
	}
	else {
		[self setCurrentTimeset:[Shared currentTimeset]];
	}
	[self setHolidays:[Shared holidays]];
	// END RETRIEVAL
	if (![self currentConstraint]) {
		[self setCurrentConstraint:[[Constraint alloc] init]];
	}
	[self makeDescription];
	[[self tableView] reloadData];
	[self setVarTimer:[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(selectCells) userInfo:nil repeats:NO]];
}

- (void)selectCells {
	for (int i=0; i<[[[self currentConstraint] qualifiers] count]; i++) {
		if ([[[[self currentConstraint] qualifiers] objectAtIndex:i] group] != NONE) {
			[[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:[[[[self currentConstraint] qualifiers] objectAtIndex:i] group] inSection:i] animated:NO scrollPosition:0];
		}
	}
}

@end
