//
//  Countdown.m
//  Countdowns
//
//  Created by raxod502 on 6/3/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "Countdown.h"

#import "CountupDetailViewController.h"
#import "CountdownDetailViewController.h"

@implementation Countdown

- (id)initWithName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset {
	if (self = [super init]) {
		[self setIsCountdown:YES];
		[self setName:name];
		[self setDate:date];
		[self setTimeset:timeset];
		[self setLastUpdate:today];
		[self setUnit:6];
		NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:today];
		[comps setSecond:0];
		[self setElapsed:[[Countdown alloc] initCountupWithName:name date:[calendar dateFromComponents:comps] timeset:timeset]];
		[self setupCountdown];
	}
	return self;
}

- (id)initCountupWithName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset {
	if (self = [super init]) {
		[self setIsCountdown:NO];
		[self setName:name];
		[self setDate:date];
		[self setTimeset:timeset];
		[self setUnit:6];
		[self setupCountup];
	}
	return self;
}

- (id)initCountupWithNoSetupAndName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset {
	if (self = [super init]) {
		[self setIsCountdown:NO];
		[self setName:name];
		[self setDate:date];
		[self setTimeset:timeset];
		[self setUnit:6];
	}
	return self;
}

- (void)kill {
    [self setShouldCancel:YES];
    [[self elapsed] setShouldCancel:YES];
    [[self currentSandbox] setShouldCancel:YES];
}

- (void)unkill {
    [self setShouldCancel:NO];
    [[self elapsed] setShouldCancel:NO];
    [[self currentSandbox] setShouldCancel:NO];
}

+ (NSString *)stringForDate:(NSDate *)date {
	NSDateComponents *comps = [calendar components:NSUIntegerMax ^ NSYearForWeekOfYearCalendarUnit fromDate:date];
	NSArray *months = @[@"[UNDEFINED]", @"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
	NSArray *weekdays = @[@"[UNDEFINED]", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
	NSInteger hour = [comps hour];
	NSString *ampm = @"[UNDEFINED]";
	if (hour >= 0 && hour <= 11) ampm = @"AM";
	if (hour >= 12 && hour <= 23) ampm = @"PM";
	hour = hour % 12;
	if (hour == 0) hour = 12;
	NSInteger minute = [comps minute];
	
	NSString *timeString = @"[UNDEFINED]";
	if (hour == 12 && minute == 0 && [ampm isEqualToString:@"PM"]) {
		timeString = @"Noon";
	}
	else {
		timeString = [NSString stringWithFormat:@"%i:%02i %@", hour, minute, ampm];
	}
	
	NSString *weekday = [weekdays objectAtIndex:[comps weekday]];
	NSString *month = [months objectAtIndex:[comps month]];
	NSInteger day = [comps day];
	NSInteger year = [comps year];
	
	NSString *dateString = [NSString stringWithFormat:@"%@, %@ %i, %i", weekday, month, day, year];
	
	NSString *format = [NSString stringWithFormat:@"%@ on %@", timeString, dateString];
	return format;
}

- (void)setupCountdown {
    [[self elapsed] setCalculating:NO];
    [[self elapsed] setWaiting:NO];
    if ([[[self timeset] self] invincible] || [today timeIntervalSinceDate:[[self elapsed] lastUpdate]] < 3600) {
        [self setCalculating:NO];
        [self setWaiting:NO];
        [self coreSetupCountdown];
        return;
    }
    CDLog2(@"[setupCountdown] %@ []", [self name]);
    [self setFinishedSetup:NO];
    [[self elapsed] setLastUpdate:[[self elapsed] date]];
    [self setDisplayShort:CDOWN_RECALC];
    [self setDisplayLong:CDOWN_RECALC_LONG];
    [self kill];
    [self setCalculating:NO];
    [self setWaiting:YES];
    CDLog2(@"Rescheduling timer (%@)", [self name]);
    [[self repeatTimer] invalidate];
    if ([NSThread isMainThread]) {
        CDLog2(@"Scheduling timer sync (%@)", [self name]);
        [self setRepeatTimer:[NSTimer scheduledTimerWithTimeInterval:SETUPDELAY target:self selector:@selector(doRepeatCountdownInBackground:) userInfo:nil repeats:YES]];
    }
    else {
        CDLog2(@"Scheduling timer async (%@)", [self name]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRepeatTimer:[NSTimer scheduledTimerWithTimeInterval:SETUPDELAY target:self selector:@selector(doRepeatCountdownInBackground:) userInfo:nil repeats:YES]];
        });
    }
}

- (void)setupCountup {
    if ([[[self timeset] self] invincible] || [today timeIntervalSinceDate:[self lastUpdate]] < 3600) {
        [self coreSetupCountup];
        return;
    }
    CDLog2(@"[setupCountup] %@ []", [self name]);
    [self setFinishedSetup:NO];
    [self setLastUpdate:[self date]];
    [self setDisplayShort:CUP_RECALC];
    [self setDisplayLong:CUP_RECALC_LONG];
    [self kill];
    [self setCalculating:NO];
    [self setWaiting:YES];
    [[self repeatTimer] invalidate];
    if ([NSThread isMainThread]) {
        CDLog2(@"Scheduling timer sync (%@)", [self name]);
        [self setRepeatTimer:[NSTimer scheduledTimerWithTimeInterval:SETUPDELAY target:self selector:@selector(doRepeatCountupInBackground:) userInfo:nil repeats:YES]];
    }
    else {
        CDLog2(@"Scheduling timer async (%@)", [self name]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRepeatTimer:[NSTimer scheduledTimerWithTimeInterval:SETUPDELAY target:self selector:@selector(doRepeatCountupInBackground:) userInfo:nil repeats:YES]];
        });
    }
}

- (void)doRepeatCountdownInBackground:(NSTimer *)theTimer {
    CDLog2(@"[doRepeatCountdownInBackground] %@ []", [self name]);
    [self performSelectorInBackground:@selector(repeatSetupCountdown:) withObject:theTimer];
}

- (void)doRepeatCountupInBackground:(NSTimer *)theTimer {
    CDLog2(@"[doRepeatCountupInBackground] %@ []", [self name]);
    [self performSelectorInBackground:@selector(repeatSetupCountup:) withObject:theTimer];
}

- (void)repeatSetupCountdown:(NSTimer *)timer {
    CDLog2(@"[repeatSetupCountdown] %@ []", [self name]);
    [self setWaiting:YES];
    
    NSTimeInterval current = [[self date] timeIntervalSinceDate:[[self elapsed] date]];
    BOOL foundShorter = NO;
    BOOL foundCalculating = NO;
    NSMutableArray *countdowns = [Shared countdowns];
    for (Countdown *countdown in countdowns) {
        if (countdown != self) {
            NSTimeInterval other = [[countdown date] timeIntervalSinceDate:[[countdown elapsed] date]];
            if ([countdown waiting] && other < current) {
                foundShorter = YES;
            }
            if ([countdown calculating]) {
                foundCalculating = YES;
                if (![countdown finishedSetup] && other > current) {
                    [countdown performSelectorInBackground:@selector(setupCountdown) withObject:nil];
                }
            }
        }
    }
    NSMutableArray *countups = [Shared countups];
    for (Countdown *countup in countups) {
        if (countup != self) {
            NSTimeInterval other = [today timeIntervalSinceDate:[countup date]];
            if ([countup waiting] && other < current) {
                foundShorter = YES;
            }
            if ([countup calculating]) {
                foundCalculating = YES;
                if (![countup finishedSetup] && other > current) {
                    [countup performSelectorInBackground:@selector(setupCountup) withObject:nil];
                }
            }
        }
    }
    if (!foundShorter && !foundCalculating) {
        CDLog2(@"Descheduling timer (%@)", [self name]);
        [timer invalidate];
        [self coreSetupCountdown];
    }
}

- (void)repeatSetupCountup:(NSTimer *)timer {
    CDLog2(@"[repeatSetupCountup] %@ []", [self name]);
    [self setWaiting:YES];
    
    NSTimeInterval current = [today timeIntervalSinceDate:[self date]];
    BOOL foundShorter = NO;
    BOOL foundCalculating = NO;
    NSMutableArray *countdowns = [Shared countdowns];
    for (Countdown *countdown in countdowns) {
        if (countdown != self) {
            NSTimeInterval other = [[countdown date] timeIntervalSinceDate:[[countdown elapsed] date]];
            if ([countdown waiting] && other < current) {
                foundShorter = YES;
            }
            if ([countdown calculating]) {
                foundCalculating = YES;
                if (![countdown finishedSetup] && other > current) {
                    [countdown performSelectorInBackground:@selector(setupCountdown) withObject:nil];
                }
            }
        }
    }
    NSMutableArray *countups = [Shared countups];
    for (Countdown *countup in countups) {
        if (countup != self) {
            NSTimeInterval other = [today timeIntervalSinceDate:[countup date]];
            if ([countup waiting] && other < current) {
                foundShorter = YES;
            }
            if ([countup calculating]) {
                foundCalculating = YES;
                if (![countup finishedSetup] && other > current) {
                    [countup performSelectorInBackground:@selector(setupCountup) withObject:nil];
                }
            }
        }
    }
    if (!foundShorter && !foundCalculating) {
        [timer invalidate];
        [self coreSetupCountup];
    }
}

- (void)coreSetupCountdown {
    NSDate *start = realdate;
    CDLog2(@"[coreSetupCountdown] %@ []", [self name]);
    [self setWaiting:NO];
	[self setCalculating:YES];
    [self unkill];
    
    CDLog(@"[CSC] coreSetupCountdown reached by '%@'...", [self name]);
	if ([self shouldCancel]) {[self setCalculating:NO]; return;}
    CDLog(@"[CSC] Resetting countup.");
	[[self elapsed] resetCountupFlags];
	if ([self shouldCancel]) {[self setCalculating:NO]; return;}
    CDLog(@"[CSC] Calculating countdown time.");
	[self createCountdownFlags];
	if ([self shouldCancel]) {[self setCalculating:NO]; return;}
    CDLog(@"[CSC] Updating countdown.");
    
    [self setCalculating:NO];
    [self realUpdateCountdown];
    [self setFinishedSetup:YES];
    
    CDLog2(@"[FINISHED cd] %@ [%i]", [self name], (int)[realdate timeIntervalSinceDate:start]);
}

- (void)coreSetupCountup {
    CDLog2(@"[coreSetupCountup] %@ []", [self name]);
    [self setWaiting:NO];
    [self setCalculating:YES];
    [self unkill];
    
    CDLog(@"[CSC] coreSetupCountup reached by '%@'...", [self name]);
    CDLog(@"[CSC] Resetting countup.");
	[self resetCountupFlags];
	if ([self shouldCancel]) {[self setCalculating:NO]; return;}
    CDLog(@"[CSC] Updating countup.");
    
    [self setCalculating:NO];
    [self realUpdateCountup];
    [self setFinishedSetup:YES];
    
    CDLog2(@"[FINISHED cu] %@ []", [self name]);
}

- (void)createCountdownFlags {
	[self setTotalTime:[self createCountdownTimeFrom:[[self elapsed] date] to:[self date]]];
}

- (void)resetCountupFlags {
    CDLog(@"[RCF] Set remaining flags to 0.");
	[self setRemainingFlags:0];
    CDLog(@"[RCF] Set last update to %@.", form([self date]));
	[self setLastUpdate:[self date]];
    CDLog(@"[RCF] Calculating flag at start date...");
	[self setFlagAtStartDate:[self checkFlagAt:[self date]]];
    CDLog(@"[RCF] Flag at start date is %@.", [self flagAtStartDate] ? @"excluded" : @"included");
    CDLog(@"[RCF] Calculating flag at current date...");
	[self setFlagAtCurrentDate:[self flagAtStartDate]];
    CDLog(@"[RCF] Flag at current date is %@.", [self flagAtCurrentDate] ? @"excluded" : @"included");
}

- (double)createCountdownTimeFrom:(NSDate *)startDate to:(NSDate *)endDate {
	// Warning: sandbox is very unsafe. Play with care.
    if ([self shouldCancel]) return 0;
	Countdown *sandbox = [[Countdown alloc] initCountupWithNoSetupAndName:@"Sandbox" date:startDate timeset:[self timeset]];
    [sandbox setContainer:self];
	[sandbox setShouldCancel:[self shouldCancel]];
    CDLog(@"[CCF] Created sandbox countup with date and lastUpdate = %@.", [sandbox date]);
    CDLog(@"[CCF] Setting up sandbox...");
    [sandbox resetCountupFlags];
	[self setCurrentSandbox:sandbox];
    CDLog(@"[CCF] Updating sandbox with today = %@...", endDate);
	double interval = [sandbox updateCountupWithToday:endDate];
    CDLog(@"[CCF] Time elapsed for sandbox:\n%f", interval);
	return interval;
}

- (double)calculateCountdownTime {
    CDLog(@"[CCT] Updating countup...");
	double sofar = [[self elapsed] realUpdateCountup];
    CDLog(@"[CCT] Time elapsed is: %f", sofar);
	double total = [self totalTime];
    CDLog(@"[CCT] Total time is: %f", total);
	
    CDLog(@"[CCT] Time remaining is: %f", total - sofar);
    
	return total - sofar;
}

- (void)updateCountdown {
    if ([[[self timeset] self] invincible] || [today timeIntervalSinceDate:[[self elapsed] lastUpdate]] < 3600) {
        CDLog(@"[UC] Performing realUpdateCountdown in foreground...");
        [self realUpdateCountdown];
    }
    else {
        CDLog(@"[UC] Performing realUpdateCountdown in background...");
        [self performSelectorInBackground:@selector(realUpdateCountdown) withObject:self];
    }
}

- (void)updateCountup {
    if ([[[self timeset] self] invincible] || [today timeIntervalSinceDate:[self lastUpdate]] < 3600) {
        CDLog(@"[UC] Performing realUpdateCountup in foreground...");
        [self realUpdateCountup];
    }
    else {
        CDLog(@"[UC] Performing realUpdateCountup in background...");
        [self performSelectorInBackground:@selector(realUpdateCountup) withObject:self];
    }
}

- (double)realUpdateCountdown {
    if (![[self elapsed] container]) [[self elapsed] setContainer:self];
    CDLog(@"---> realUpdateCountdown called for '%@' with '%@'.", [self name], [[self timeset] name]);
    
    if ([self calculating] || [[self elapsed] calculating] || [self waiting]) {
		return 0;
	}
    
    [self setDisplayShort:CDOWN_RECALC];
    [self setDisplayLong:CDOWN_RECALC_LONG];
    
	if ([[self date] compare:nowdate] != NSOrderedDescending) {
		[self setDisplayShort:@"This countdown has expired."];
		[self setDisplayLong:@"This countdown has expired."];
        [[self elapsed] setLastUpdate:realdate];
        CDLog(@"[RUC] Countdown is expired, returning.");
		return 0;
	}
	
	if ([[[self elapsed] date] compare:nowdate] != NSOrderedAscending) {
		[self setDisplayShort:@"This countdown has not yet started."];
		[self setDisplayLong:@"The start date of this countdown\nhas not yet passed."];
        [[self elapsed] setLastUpdate:realdate];
        CDLog(@"[RUC] Countdown's countup has not yet started, returning.");
		return 0;
	}
	
    if ([today compare:[[self elapsed] lastUpdate]] == NSOrderedAscending) {
        [self performSelectorInBackground:@selector(setupCountdown) withObject:nil];
        return 0;
	}
    
    [self setCalculating:YES];
    
    CDLog(@"[RUC] Calculating time remaining...");
    double timeRemaining = [self calculateCountdownTime];
    NSDateComponents *rv = [calendar components:[Countdown componentsForUnit:[self unit]] fromDate:[NSDate dateWithTimeInterval:-timeRemaining sinceDate:[self date]] toDate:[self date] options:0];
    [self setSecondHalf:[[self elapsed] secondHalf]];
    [self setFirstHalf:timeRemaining];
	if ([self shouldCancel]) {[self setCalculating:NO]; return 0;}
	
	[self setDisplayComps:rv];
	
	NSDateComponents *diff = rv;
	
    NSString *prefix = @"Time remaining: ";
    
	NSMutableString *str = [NSMutableString stringWithString:prefix];
	
	int anything = 0;
	if ([diff year] > 0 && [diff year] != NSIntegerMax) {
		[str appendFormat:@"%i year%@, ", [diff year], plural([diff year])];
		anything += 1;
	}
	if ([diff month] > 0 && [diff month] != NSIntegerMax) {
		[str appendFormat:@"%i month%@%@", [diff month], plural([diff month]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff weekOfYear] > 0 && anything < 2 && [diff weekOfYear] != NSIntegerMax) {
		[str appendFormat:@"%i week%@%@", [diff weekOfYear], plural([diff weekOfYear]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff day] > 0 && anything < 2 && [diff day] != NSIntegerMax) {
		[str appendFormat:@"%i day%@%@", [diff day], plural([diff day]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff hour] > 0 && anything < 2 && [diff hour] != NSIntegerMax) {
		[str appendFormat:@"%i hour%@%@", [diff hour], plural([diff hour]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff minute] > 0 && anything < 2 && [diff minute] != NSIntegerMax) {
		[str appendFormat:@"%i minute%@%@", [diff minute], plural([diff minute]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff second] > 0 && anything < 2 && [diff second] != NSIntegerMax) {
		[str appendFormat:@"%i second%@%@", [diff second], plural([diff second]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	
	switch (anything) {
		case 0:
			str = [NSMutableString stringWithString:@"This countdown has expired."];
			break;
		case 1:
			str = [NSMutableString stringWithString:[str substringToIndex:[str length]-2]];
			break;
		default:
			break;
	}
	
    NSMutableString *shortCopy = str;
	
	str = [NSMutableString stringWithString:@"Time remaining until\n"];
    [str appendFormat:@"%@", [Countdown stringForDate:[self date]]];
	[str appendString:@":\n\n"];
	
	if ([diff year] > 0 && [diff year] != NSIntegerMax) {
		[str appendFormat:@"%i year%@\n", [diff year], plural([diff year])];
		anything += 1;
	}
	if ([diff month] > 0 && [diff month] != NSIntegerMax) {
		[str appendFormat:@"%i month%@\n", [diff month], plural([diff month])];
		anything += 1;
	}
	if ([diff weekOfYear] > 0 && [diff weekOfYear] != NSIntegerMax) {
		[str appendFormat:@"%i week%@\n", [diff weekOfYear], plural([diff weekOfYear])];
		anything += 1;
	}
	if ([diff day] > 0 && [diff day] != NSIntegerMax) {
		[str appendFormat:@"%i day%@\n", [diff day], plural([diff day])];
		anything += 1;
	}
	if ([diff hour] > 0 && [diff hour] != NSIntegerMax) {
		[str appendFormat:@"%i hour%@\n", [diff hour], plural([diff hour])];
		anything += 1;
	}
	if ([diff minute] > 0 && [diff minute] != NSIntegerMax) {
		[str appendFormat:@"%i minute%@\n", [diff minute], plural([diff minute])];
		anything += 1;
	}
	if ([diff second] > 0) {
		[str appendFormat:@"%i second%@\n", [diff second], plural([diff second])];
		anything += 1;
	}
	if (!anything) {
		str = [NSMutableString stringWithString:@"This countdown has expired."];
	}
	
	[self setDisplayShort:shortCopy];
	[self setDisplayLong:str];
	
    CDLog(@"[RUC] Verifying units...");
	[self verifyUnits];
	
    CDLog(@"[RUC] Finished updating.");
    
    [self setCalculating:NO];
    
	return timeRemaining;
}

- (double)realUpdateCountup {
    CDLog(@"---> realUpdateCountup called for '%@' with '%@'.", [self name], [[self timeset] name]);
    
    NSInteger secs = [[calendar components:NSSecondCalendarUnit fromDate:[self date]] second];
    if (secs) {
        if (secs >= 30) secs = 60 - secs;
        else secs = -secs;
        [self setDate:[NSDate dateWithTimeInterval:secs sinceDate:[self date]]];
    }
    if ([self container]) {
        NSInteger secs2 = [[calendar components:NSSecondCalendarUnit fromDate:[[self container] date]] second];
        if (secs2) {
            if (secs2 >= 30) secs2 = 60 - secs2;
            else secs2 = -secs2;
            [[self container] setDate:[NSDate dateWithTimeInterval:secs sinceDate:[self date]]];
        }
    }
    
    if ([self calculating] || [self waiting]) {
        return 0;
    }
    
    [self setDisplayShort:CUP_RECALC];
    [self setDisplayLong:CUP_RECALC_LONG];
	
	if ([[self date] compare:nowdate] != NSOrderedAscending) {
		[self setDisplayShort:@"This countup has not yet started."];
		[self setDisplayLong:@"This countup has not yet started."];
        CDLog(@"[RUC] Countup has not yet started, returning.");
		return 0;
	}
	
    if ([today compare:[self lastUpdate]] == NSOrderedAscending) {
        if ([self isCountdown]) {
            [[self container] performSelectorInBackground:@selector(setupCountdown) withObject:nil];
        }
        else {
            [self performSelectorInBackground:@selector(setupCountup) withObject:nil];
        }
        return 0;
	}
    
    [self setCalculating:YES];
    
    CDLog(@"[RUC] Calculating time elapsed...");
    double timeElapsed = [self updateCountupWithToday:today];
    NSDateComponents *rv = [calendar components:[Countdown componentsForUnit:[self unit]] fromDate:[self date] toDate:[NSDate dateWithTimeInterval:timeElapsed sinceDate:[self date]] options:0];
    [self setSecondHalf:timeElapsed];
	if ([self shouldCancel]) {[self setCalculating:NO]; return 0;}
	
	[self setDisplayComps:rv];
	
	NSDateComponents *diff = rv;
	
    NSString *suffix = @"Time elapsed: ";
    
	NSMutableString *str = [NSMutableString stringWithString:suffix];
	
	int anything = 0;
	if ([diff year] > 0 && [diff year] != NSIntegerMax) {
		[str appendFormat:@"%i year%@, ", [diff year], plural([diff year])];
		anything += 1;
	}
	if ([diff month] > 0 && [diff month] != NSIntegerMax) {
		[str appendFormat:@"%i month%@%@", [diff month], plural([diff month]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff weekOfYear] > 0 && anything < 2 && [diff weekOfYear] != NSIntegerMax) {
		[str appendFormat:@"%i week%@%@", [diff weekOfYear], plural([diff weekOfYear]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff day] > 0 && anything < 2 && [diff day] != NSIntegerMax) {
		[str appendFormat:@"%i day%@%@", [diff day], plural([diff day]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff hour] > 0 && anything < 2 && [diff hour] != NSIntegerMax) {
		[str appendFormat:@"%i hour%@%@", [diff hour], plural([diff hour]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff minute] > 0 && anything < 2 && [diff minute] != NSIntegerMax) {
		[str appendFormat:@"%i minute%@%@", [diff minute], plural([diff minute]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	if ([diff second] > 0 && anything < 2 && [diff second] != NSIntegerMax) {
		[str appendFormat:@"%i second%@%@", [diff second], plural([diff second]), anything == 0 ? @", ": @""];
		anything += 1;
	}
	
	switch (anything) {
		case 0:
			str = [NSMutableString stringWithString:@"This countup has not yet started."];
			break;
		case 1:
			str = [NSMutableString stringWithString:[str substringToIndex:[str length]-2]];
			break;
		default:
			break;
	}
	
    NSMutableString *shortCopy = str;
	
	str = [NSMutableString stringWithString:@"Time elapsed since\n"];
    [str appendFormat:@"%@", [Countdown stringForDate:[self date]]];
	[str appendString:@":\n\n"];
	
	if ([diff year] > 0 && [diff year] != NSIntegerMax) {
		[str appendFormat:@"%i year%@\n", [diff year], plural([diff year])];
		anything += 1;
	}
	if ([diff month] > 0 && [diff month] != NSIntegerMax) {
		[str appendFormat:@"%i month%@\n", [diff month], plural([diff month])];
		anything += 1;
	}
	if ([diff weekOfYear] > 0 && [diff weekOfYear] != NSIntegerMax) {
		[str appendFormat:@"%i week%@\n", [diff weekOfYear], plural([diff weekOfYear])];
		anything += 1;
	}
	if ([diff day] > 0 && [diff day] != NSIntegerMax) {
		[str appendFormat:@"%i day%@\n", [diff day], plural([diff day])];
		anything += 1;
	}
	if ([diff hour] > 0 && [diff hour] != NSIntegerMax) {
		[str appendFormat:@"%i hour%@\n", [diff hour], plural([diff hour])];
		anything += 1;
	}
	if ([diff minute] > 0 && [diff minute] != NSIntegerMax) {
		[str appendFormat:@"%i minute%@\n", [diff minute], plural([diff minute])];
		anything += 1;
	}
	if ([diff second] > 0) {
		[str appendFormat:@"%i second%@\n", [diff second], plural([diff second])];
		anything += 1;
	}
	if (!anything) {
		str = [NSMutableString stringWithString:@"This countup has not yet started."];
	}
	
    [self setDisplayShort:shortCopy];
	[self setDisplayLong:str];
    
    CDLog(@"[RUC] Verifying units...");
	[self verifyUnits];
	
    CDLog(@"[RUC] Finished updating.");
    
    [self setCalculating:NO];
    
	return timeElapsed;
}

- (double)updateCountupWithToday:(NSDate *)now {
	double original = [now timeIntervalSinceDate:[self date]];
    CDLog(@"[UCwT] Original time interval is %f.", original);
	
	if ([[[self timeset] self] invincible]) {
        [self setLastUpdate:now];
        return original;
	}
	int diff;
	if ([[self lastUpdate] timeIntervalSinceDate:[self date]] < 0.5) {
        CDLog(@"[UCwT] Last update is at the start date, calculating initial flags from %@ to %@...", form([self lastUpdate]), form(now));
		diff = [self calculateFlagsFrom:[self lastUpdate] to:now];
        CDLog(@"[UCwT] Should exclude %i flags initially.", diff);
		if ([self shouldCancel]) return 0;
        CDLog(@"[UCwT] Initial update has occurred, checking flag at %@.", form(now));
		[self setFlagAtCurrentDate:[self checkFlagAt:now]];
        CDLog(@"[UCwT] Flag at current date is %@.", [self flagAtCurrentDate] ? @"excluded" : @"included");
		if ([self shouldCancel]) return 0;
	}
	else if ([self indicesBetweenDate:[self lastUpdate] andDate:now] >= 1) {
        CDLog(@"[UCwT] Update covers flag boundary.");
        CDLog(@"[UCwT] Calculating diff flags from %@ to %@...", form([self lastUpdate]), form(now));
		diff = [self updateFlagsFrom:[self lastUpdate] to:now];
        CDLog(@"[UCwT] Should exclude %i additional flags.", diff);
        CDLog(@"[UCwT] Checking flag at %@.", form(now));
		[self setFlagAtCurrentDate:[self checkFlagAt:now]];
        CDLog(@"[UCwT] Flag at current date is %@.", [self flagAtCurrentDate] ? @"excluded" : @"included");
		if ([self shouldCancel]) return 0;
	}
    else {
        CDLog(@"[UCwT] Update does not cover flag boundary.");
        diff = 0;
    }
    
    CDLog(@"[UCwT] Remaining flags changed from %i to %i.", [self remainingFlags], [self remainingFlags] + diff);
	[self setRemainingFlags:[self remainingFlags] + diff];
	
    CDLog(@"[UCwT] Changing last update from %@ to %@.", form([self lastUpdate]), form(now));
	[self setLastUpdate:now];
	
	double offset2 = 0;
	if ([self flagAtStartDate]) {
		NSDateComponents *comps = [CountupDetailViewController lastIndexFromCompsExclusive:[calendar components:NSMaxCalendarUnit fromDate:[self date]] withDelay:[[self timeset] delay]];
		NSDate *indexDate = [calendar dateFromComponents:comps];
		offset2 = [[self date] timeIntervalSinceDate:indexDate];
        CDLog(@"[UCwT] Start date is excluded, offsetting by %f.", offset2);
	}
    else {
        CDLog(@"[UCwT] Start date is not excluded.");
    }
	double offset = 0;
	if ([self flagAtCurrentDate]) {
		NSDateComponents *comps = [CountdownDetailViewController nextIndexFromComps:[calendar components:NSMaxCalendarUnit fromDate:now] withDelay:[[self timeset] delay]];
		NSDate *indexDate = [calendar dateFromComponents:comps];
		offset = [indexDate timeIntervalSinceDate:now];
        CDLog(@"[UCwT] Current date is excluded, offsetting by %f.", offset);
	}
    else {
        CDLog(@"[UCwT] Current date is not excluded.");
    }
	
	double finalOffset = ((double)[self remainingFlags])*((double)[[self timeset] delay])-offset-offset2;
    CDLog(@"[UCwT] Calculating finalOffset as %i * %i - %f - %f = %f.", [self remainingFlags], [[self timeset] delay], offset, offset2, finalOffset);
    CDLog(@"[UCwT] Changing original time interval from %f to %f.", original, original - finalOffset);
	original -= finalOffset;
	
    CDLog(@"[UCwT] Returning interval: %f", original);
    
	return original;
}

- (void)verifyUnits {
    int originalUnit = [self unit];
	for (int i=[self unit]; i<[UNIT_DISPLAY count]; i++) {
		if ([self isCountdown]) {
			[self setUnit:i];
			[[self elapsed] setUnit:i];
            if ([self unit] != originalUnit && !([self displayComps] && [[self elapsed] displayComps])) {
                [self updateCountdown];
                return;
            }
			NSDateComponents *cdcomps = [calendar components:[Countdown componentsForUnit:i] fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[calendar dateByAddingComponents:[self displayComps] toDate:[NSDate dateWithTimeIntervalSince1970:0] options:0] options:0];
			NSDateComponents *cucomps = [calendar components:[Countdown componentsForUnit:i] fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[calendar dateByAddingComponents:[[self elapsed] displayComps] toDate:[NSDate dateWithTimeIntervalSince1970:0] options:0] options:0];
			if ([self displayComps] && [[self elapsed] displayComps] && cdcomps && cucomps && [Countdown componentFromComps:cdcomps withUnit:i] != NSIntegerMax && [Countdown componentFromComps:cucomps withUnit:i] != NSIntegerMax) {
				break;
			}
		}
		else {
			[self setUnit:i];
            if ([self unit] != originalUnit && ![self displayComps]) {
                [self updateCountup];
                return;
            }
			NSDateComponents *cucomps = [calendar components:[Countdown componentsForUnit:i] fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[calendar dateByAddingComponents:[self displayComps] toDate:[NSDate dateWithTimeIntervalSince1970:0] options:0] options:0];
			if ([self displayComps] && cucomps && [Countdown componentFromComps:cucomps withUnit:i] != NSIntegerMax) {
				break;
			}
		}
	}
}

- (NSDateComponents *)normalize:(NSDateComponents *)comps {
	return [calendar components:[Countdown componentsForUnit:[self unit]] fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[calendar dateByAddingComponents:comps toDate:[NSDate dateWithTimeIntervalSince1970:0] options:0] options:0];
}

- (BinaryArray *)coreCalculateFrom:(NSDate *)startDate to:(NSDate *)endDate {
    CDLog(@"* Calculating flags from %@ to %@...", form(startDate), form(endDate));
	if ([[[self timeset] self] invincible]) {
		return 0;
	}
	int hours = [self indicesBetweenDate:startDate andDate:endDate]+1;
    CDLog(@"* There are %i indices between the start and end dates.", hours);
    
	BinaryArray *flags = [[BinaryArray alloc] initWithOnesAndCount:hours];
	if ([self shouldCancel]) return nil;
	[flags setStartDate:[calendar dateFromComponents:[CountupDetailViewController lastIndexFromCompsExclusive:[calendar components:NSMaxCalendarUnit fromDate:startDate] withDelay:[[self timeset] delay]]]];
    CDLog(@"* Start date %@ is at index %i.", startDate, [self indexForDate:startDate usingFlags:flags]);
    CDLog(@"* End date %@ is at index %i.", endDate, [self indexForDate:endDate usingFlags:flags]);
    CDLogF(@"* Starting with flags %@.", flags);
	if ([self shouldCancel]) return nil;
	// Flag = 1 means to include the time.
	for (int j=0; j<[[[self timeset] constraints] count]; j++) {
		Constraint *constraint = [[[self timeset] constraints] objectAtIndex:j];
        if ([[[constraint qualifiers] objectAtIndex:2] group] != NONE) {
            NSMutableArray *holidays = [Shared holidays];
            Constraint *newConstraint = [[holidays objectAtIndex:[[[[constraint qualifiers] objectAtIndex:2] datums] integerAtIndex:0]] copy];
            [newConstraint setState:[constraint state]];
            constraint = newConstraint;
        }
        CDLog(@"* Processing constraint '%@'.", [constraint descriptor]);
		BinaryArray *qualFlags = [[BinaryArray alloc] initWithOnesAndCount:hours];
		if ([self shouldCancel]) return nil;
		[qualFlags setStartDate:[flags startDate]];
		if ([self shouldCancel]) return nil;
		for (int q=0; q<[[constraint qualifiers] count]; q++) {
            Qualifier *qualifier = [[constraint qualifiers] objectAtIndex:q];
			if ([qualifier group] != NONE) {
				[self performQualifier:qualifier ofType:q onFlags:qualFlags fromDate:startDate toDate:endDate];
				if ([self shouldCancel]) return nil;
			}
		}
        CDLogF(@"* Constraint flags are:\n%@.", qualFlags);
        CDLogF(@"* Normal flags are:\n%@.", flags);
        if ([[constraint state] isEqualToString:@"Exclude"]) {
            [flags performNotImpliesWith:qualFlags];
        }
        else if ([[constraint state] isEqualToString:@"Include"]) {
            [flags performOrWith:qualFlags];
        }
        else {
            ERLog(@"[WARNING] Invalid or missing constraint state.");
        }
        if ([self shouldCancel]) return nil;
        CDLogF(@"* Transformed normal flags to:\n%@.", flags);
	}
    CDLog(@"* Finished calculating, returning.");
	return flags;
}

- (int)calculateFlagsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	BinaryArray *flags = [self coreCalculateFrom:startDate to:endDate];
	if ([self shouldCancel]) return 0;
    CDLogF(@"[CFF] Processing flags:\n%@", flags);
    CDLog(@"[CFF] Counting first flag.");
	int total = 0;
	for (int i=0; i<[flags count]; i++) {
		total += ![flags getValueAtIndex:i];
        if ([self shouldCancel]) return 0;
	}
    CDLog(@"[CFF] Total flags included = %i, total flags excluded = %i (returning latter).", [flags count] - total, total);
	return total;
}

- (int)updateFlagsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	int hours = [self indicesBetweenDate:startDate andDate:endDate]+1;
	if (hours <= 1) return 0;
	BinaryArray *flags = [self coreCalculateFrom:startDate to:endDate];
	if ([self shouldCancel]) return 0;
    CDLogF(@"[CFF] Processing flags:\n%@", flags);
    CDLog(@"[CFF] Not counting first flag.");
	int total = 0;
	for (int i=1; i<[flags count]; i++) {
		total += ![flags getValueAtIndex:i];
        if ([self shouldCancel]) return 0;
	}
    CDLog(@"[CFF] Total flags included = %i, total flags excluded = %i (returning latter).", [flags count]-1 - total, total);
	return total;
}

- (BOOL)shouldAddHourForDaylightSavingsTransitionAt:(NSDate *)date {
	if ( [[NSTimeZone systemTimeZone] isDaylightSavingTimeForDate:[NSDate dateWithTimeInterval:-1 sinceDate:date]] &&
		![[NSTimeZone systemTimeZone] isDaylightSavingTimeForDate:[NSDate dateWithTimeInterval:1 sinceDate:date]]) {
		return NO;
	}
	if (![[NSTimeZone systemTimeZone] isDaylightSavingTimeForDate:[NSDate dateWithTimeInterval:-1 sinceDate:date]] &&
		 [[NSTimeZone systemTimeZone] isDaylightSavingTimeForDate:[NSDate dateWithTimeInterval:1 sinceDate:date]]) {
		return YES;
	}
	ERLog(@"[ERROR] Did not receive valid result from daylight savings checking function.");
	return NO;
}

- (BOOL)checkFlagAt:(NSDate *)date {
    BOOL rv;
    if ([self offsetForDate:date]) {
        rv = [self updateFlagsFrom:[NSDate dateWithTimeInterval:-1 sinceDate:date] to:date];
    }
    else {
        rv = [self calculateFlagsFrom:date to:date];
    }
	return rv;
}

- (void)performQualifier:(Qualifier *)qualifier ofType:(int)type onFlags:(BinaryArray *)flags fromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
	BinaryArray *tempFlags = [[BinaryArray alloc] initWithZerosAndCount:[flags count]];
	[tempFlags setStartDate:[flags startDate]];
	// tempFlags = 1 means time intended by the qualifier
	NSDateComponents *subtractWeek = [NSDateComponents new];
	[subtractWeek setDay:-7];
	NSDateComponents *addWeek = [NSDateComponents new];
	[addWeek setDay:7];
	NSDateComponents *addDay = [NSDateComponents new];
	[addDay setDay:1];
	switch (type) { // GUAVA
		case 0:
			switch ([qualifier group]) {
				case SPECIFIC_YEAR: {
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setMonth:1];
					[comps setDay:1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					[comps setYear:[[qualifier datums] integerAtIndex:0]];
					NSDate *start = [calendar dateFromComponents:comps];
					[comps setYear:[comps year]+1];
					NSDate *end = [calendar dateFromComponents:comps];
					if ([self shouldCancel]) return;
					[self flagDatesFrom:start to:end for:tempFlags];
					break;
				}
				case RANGE_OF_YEARS: {
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setMonth:1];
					[comps setDay:1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					[comps setYear:[[qualifier datums] integerAtIndex:0]];
					NSDate *start = [calendar dateFromComponents:comps];
					[comps setYear:[[qualifier datums] integerAtIndex:1]+1];
					NSDate *end = [calendar dateFromComponents:comps];
					if ([self shouldCancel]) return;
					[self flagDatesFrom:start to:end for:tempFlags];
					break;
				}
				default:
					break;
			}
			break;
		case 1:
			switch ([qualifier group]) {
				case SPECIFIC_MONTH: {
					int startingYear = [[calendar components:NSYearCalendarUnit fromDate:startDate] year];
					int endingYear = [[calendar components:NSYearCalendarUnit fromDate:endDate] year];
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setDay:1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					for (int year=startingYear; year<=endingYear; year++) {
						[comps setYear:year];
						[comps setMonth:[[qualifier datums] integerAtIndex:0]+1];
						NSDate *start = [calendar dateFromComponents:comps];
						[comps setMonth:[[qualifier datums] integerAtIndex:0]+2];
						NSDate *end = [calendar dateFromComponents:comps];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:start to:end for:tempFlags];
					}
					break;
				}
				case RANGE_OF_MONTHS: {
					int startingYear = [[calendar components:NSYearCalendarUnit fromDate:startDate] year]-1;
					int endingYear = [[calendar components:NSYearCalendarUnit fromDate:endDate] year];
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setDay:1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					for (int year=startingYear; year<=endingYear; year++) {
						[comps setYear:year];
						[comps setMonth:[[qualifier datums] integerAtIndex:0]+1];
						NSDate *start = [calendar dateFromComponents:comps];
						[comps setMonth:[[qualifier datums] integerAtIndex:1]+2];
						if ([[qualifier datums] integerAtIndex:0] > [[qualifier datums] integerAtIndex:1]) {
							[comps setYear:[comps year]+1];
						}
						NSDate *end = [calendar dateFromComponents:comps];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:start to:end for:tempFlags];
					}
					break;
				}
				default:
					break;
			}
			break;
		case 3:
			switch ([qualifier group]) {
				case SPECIFIC_DAY_IN_YEAR: {
					int startingYear = [[calendar components:NSYearCalendarUnit fromDate:startDate] year];
					int endingYear = [[calendar components:NSYearCalendarUnit fromDate:endDate] year];
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					for (int year=startingYear; year<=endingYear; year++) {
						[comps setYear:year];
						[comps setMonth:[[qualifier datums] integerAtIndex:0]+1];
						[comps setDay:[[qualifier datums] integerAtIndex:1]+1];
                        if ([Countdown validDate:comps]) {
                            NSDate *start = [calendar dateFromComponents:comps];
                            [comps setDay:[comps day]+1];
                            NSDate *end = [calendar dateFromComponents:comps];
                            if ([self shouldCancel]) return;
                            [self flagDatesFrom:start to:end for:tempFlags];
                        }
					}
					break;
				}
				case SPECIFIC_DAY_IN_MONTH: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:startDate];
					[comps setDay:[[qualifier datums] integerAtIndex:0]+1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					NSDateComponents *tcomps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[tcomps setDay:[[qualifier datums] integerAtIndex:0]+1];
					[tcomps setHour:0];
					[tcomps setMinute:0];
					[tcomps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:tcomps];
					NSDate *date;
					while ([date compare:lastDate] <= 0) {
                        date = [calendar dateFromComponents:comps];
                        if ([Countdown validDate:comps]) {
                            tcomps = [comps copy];
                            [tcomps setDay:[comps day]+1];
                            NSDate *endDate = [calendar dateFromComponents:tcomps];
                            if ([self shouldCancel]) return;
                            [self flagDatesFrom:date to:endDate for:tempFlags];
                        }
						[comps setMonth:[comps month]+1];
						if ([comps month] == 13) {
							[comps setYear:[comps year]+1];
							[comps setMonth:1];
						}
					}
					break;
				}
				case RANGE_OF_DAYS_IN_YEAR: {
					int startingYear = [[calendar components:NSYearCalendarUnit fromDate:startDate] year];
					int endingYear = [[calendar components:NSYearCalendarUnit fromDate:endDate] year];
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					for (int year=startingYear; year<=endingYear; year++) {
						[comps setYear:year];
						[comps setMonth:[[qualifier datums] integerAtIndex:0]+1];
						[comps setDay:[[qualifier datums] integerAtIndex:1]+1];
                        comps = [Countdown validateDate:comps];
						NSDate *dayStartDate = [calendar dateFromComponents:comps];
						[comps setMonth:[[qualifier datums] integerAtIndex:2]+1];
						[comps setDay:[[qualifier datums] integerAtIndex:3]+2];
                        comps = [Countdown validateDate:comps];
						NSDate *dayEndDate = [calendar dateFromComponents:comps];
						if ([dayEndDate compare:dayStartDate] < 0) {
							[comps setYear:[comps year]+1];
						}
						dayEndDate = [calendar dateFromComponents:comps];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:dayStartDate to:dayEndDate for:tempFlags];
					}
					break;
				}
				case RANGE_OF_DAYS_IN_MONTH: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:startDate];
                    [comps setMonth:[comps month]-1];
                    if ([comps month] == 0) {
                        [comps setMonth:12];
                        [comps setYear:[comps year]-1];
                    }
					[comps setDay:[[qualifier datums] integerAtIndex:0]+1];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					NSDateComponents *tcomps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[tcomps setDay:MAX([[qualifier datums] integerAtIndex:0],[[qualifier datums] integerAtIndex:1])+1];
					[tcomps setHour:0];
					[tcomps setMinute:0];
					[tcomps setSecond:0];
					NSDate *lastDate = [calendar dateFromComponents:tcomps];
					NSDate *date;
					while ([date compare:lastDate] <= 0) {
                        date = [calendar dateFromComponents:[Countdown validateDate:comps]];
                        if (YES) {
                            tcomps = [comps copy];
                            [tcomps setDay:[[qualifier datums] integerAtIndex:1]+2];
                            if ([[qualifier datums] integerAtIndex:1] < [[qualifier datums] integerAtIndex:0]) {
                                [tcomps setMonth:[tcomps month]+1];
                                if ([tcomps month] == 13) {
                                    [tcomps setYear:[tcomps year]+1];
                                    [tcomps setMonth:1];
                                }
                            }
                            NSDate *endDate = [calendar dateFromComponents:[Countdown validateDate:tcomps]];
                            if ([self shouldCancel]) return;
                            [self flagDatesFrom:date to:endDate for:tempFlags];
                        }
                        [comps setMonth:[comps month]+1];
                        if ([comps month] == 13) {
                            [comps setYear:[comps year]+1];
                            [comps setMonth:1];
                        }
					}
					break;
				}
				default:
					break;
			}
			break;
		case 4:
			switch ([qualifier group]) {
				case DAY_OF_WEEK: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtractWeek toDate:startDate options:0]];
					NSDateComponents *subtract = [NSDateComponents new];
					[subtract setDay:-([comps weekday] - ([[qualifier datums] integerAtIndex:0]+1))-7];
					comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtract toDate:startDate options:0]];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date;
					for (date = firstDate; [date compare:lastDate] <= 0; date = [calendar dateByAddingComponents:addWeek toDate:date options:0]) {
						NSDate *endDate = [calendar dateByAddingComponents:addDay toDate:date options:0];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:date to:endDate for:tempFlags];
					}
					break;
				}
				case WEEKDAYS: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtractWeek toDate:startDate options:0]];
					NSDateComponents *subtract = [NSDateComponents new];
					[subtract setDay:-([comps weekday] + 5)];
					comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtract toDate:startDate options:0]];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date;
					for (date = firstDate; [date compare:lastDate] <= 0; date = [calendar dateByAddingComponents:addWeek toDate:date options:0]) {
						NSDateComponents *addFiveDays = [NSDateComponents new];
						[addFiveDays setDay:5];
						NSDate *endDate = [calendar dateByAddingComponents:addFiveDays toDate:date options:0];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:date to:endDate for:tempFlags];
					}
					break;
				}
				case WEEKENDS: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtractWeek toDate:startDate options:0]];
					NSDateComponents *subtract = [NSDateComponents new];
					[subtract setDay:-[comps weekday]];
					comps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateByAddingComponents:subtract toDate:startDate options:0]];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date;
					for (date = firstDate; [date compare:lastDate] <= 0; date = [calendar dateByAddingComponents:addWeek toDate:date options:0]) {
						NSDateComponents *addTwoDays = [NSDateComponents new];
						[addTwoDays setDay:2];
						NSDate *endDate = [calendar dateByAddingComponents:addTwoDays toDate:date options:0];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:date to:endDate for:tempFlags];
					}
					break;
				}
				case SPECIFIC_DAY_OF_WEEK_IN_MONTH: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:startDate];
					[comps setMonth:[comps month]-1];
					[comps setDay:15];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[comps setMonth:[comps month]+1];
					[comps setDay:15];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date = firstDate;
                    comps = [calendar components:NSMaxCalendarUnit fromDate:date];
					while ([date compare:lastDate] <= 0) {
                        date = [calendar dateFromComponents:comps];
						NSDateComponents *weekday = [NSDateComponents new];
						[weekday setHour:0];
						[weekday setMinute:0];
						[weekday setSecond:0];
						[weekday setYear:[comps year]];
						[weekday setMonth:[comps month]];
						[weekday setWeekday:[[qualifier datums] integerAtIndex:0]+1];
						if ([[qualifier datums] integerAtIndex:1] == 5) {
							[weekday setMonth:[weekday month]+1];
							[weekday setWeekdayOrdinal:1];
							weekday = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:weekday]];
							[weekday setDay:[weekday day]-7];
							weekday = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:weekday]];
						}
						else {
							[weekday setWeekdayOrdinal:[[qualifier datums] integerAtIndex:1]+1];
							weekday = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:weekday]];
						}
                        if ([comps month] == [weekday month]) {
                            NSDate *start = [calendar dateFromComponents:weekday];
                            [weekday setDay:[weekday day]+1];
                            NSDate *endDate = [calendar dateFromComponents:weekday];
                            if ([self shouldCancel]) return;
                            [self flagDatesFrom:start to:endDate for:tempFlags];
                        }
						[comps setMonth:[comps month]+1];
						if ([comps month] == 13) {
							[comps setYear:[comps year]+1];
							[comps setMonth:1];
						}
					}
					break;
				}
				case EVERY_OTHER_DAY_OF_WEEK: {
					NSDateComponents *comps = [[NSDateComponents alloc] init];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:0];
					[comps setYear:[[qualifier datums] integerAtIndex:3]];
					[comps setMonth:[[qualifier datums] integerAtIndex:1]+1];
					[comps setDay:[[qualifier datums] integerAtIndex:2]+1];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					while ([firstDate compare:startDate] == NSOrderedDescending) {
						if ([self shouldCancel]) return;
						comps = [calendar components:NSMaxCalendarUnit fromDate:firstDate];
						[comps setDay:[comps day]-14];
						firstDate = [calendar dateFromComponents:comps];
					}
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
					[comps setHour:0];
					[comps setMinute:0];
					[comps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date;
					NSDateComponents *addTwoWeeks = [NSDateComponents new];
					[addTwoWeeks setDay:14];
					for (date = firstDate; [date compare:lastDate] <= 0; date = [calendar dateByAddingComponents:addTwoWeeks toDate:date options:0]) {
						NSDate *endDate = [calendar dateByAddingComponents:addDay toDate:date options:0];
						if ([self shouldCancel]) return;
						[self flagDatesFrom:date to:endDate for:tempFlags];
					}
					break;
				}
				default:
					break;
			}
			break;
		case 5:
			switch ([qualifier group]) {
				case RANGE_OF_TIME: {
					NSDateComponents *comps = [calendar components:NSMaxCalendarUnit fromDate:startDate];
                    [comps setDay:[comps day]-1];
					[comps setHour:[[qualifier datums] integerAtIndex:0]];
					[comps setMinute:[[qualifier datums] integerAtIndex:1]*5];
					[comps setSecond:0];
					NSDate *firstDate = [calendar dateFromComponents:comps];
					comps = [calendar components:NSMaxCalendarUnit fromDate:endDate];
                    [comps setDay:[comps day]+1];
					[comps setHour:[[qualifier datums] integerAtIndex:2]];
					[comps setMinute:[[qualifier datums] integerAtIndex:3]*5];
					[comps setSecond:1];
					NSDate *lastDate = [calendar dateFromComponents:comps];
					NSDate *date;
					for (date = firstDate; [date compare:lastDate] <= 0; date = [calendar dateByAddingComponents:addDay toDate:date options:0]) {
						NSDateComponents *timeToAdd = [NSDateComponents new];
						[timeToAdd setHour:[[qualifier datums] integerAtIndex:2] - [[qualifier datums] integerAtIndex:0]];
						[timeToAdd setMinute:([[qualifier datums] integerAtIndex:3] - [[qualifier datums] integerAtIndex:1])*5];
						NSDate *endDate = [calendar dateByAddingComponents:timeToAdd toDate:date options:0];
						if ([endDate compare:date] < 0) {
							endDate = [calendar dateByAddingComponents:addDay toDate:endDate options:0];
						}
						if ([self shouldCancel]) return;
						[self flagDatesFrom:date to:endDate for:tempFlags];
					}
					break;
				}
				default:
					break;
			}
			break;
		default:
			break;
	}
	if ([self shouldCancel]) return;
    [flags performAndWith:tempFlags];
}

- (int)indexForDate:(NSDate *)date usingFlags:(BinaryArray *)flags {
	int rv = [self indicesBetweenDate:[flags startDate] andDate:date];
	return rv;
}

- (int)indexForDateExclusive:(NSDate *)date usingFlags:(BinaryArray *)flags {
	int rv = [self indicesBetweenDate:[flags startDate] andDate:date];
	rv -= [self offsetForDate:date];
	return rv;
}

- (BOOL)cuspOffsetForDate:(NSDate *)date {
    if ([self indicesBetweenDate:date andDate:[NSDate dateWithTimeInterval:1 sinceDate:date]] >= 1) {
        return YES;
    }
    return NO;
}

- (BOOL)offsetForDate:(NSDate *)date {
	if ([self indicesBetweenDate:[NSDate dateWithTimeInterval:-1 sinceDate:date] andDate:date] >= 1) {
		return YES;
	}
	return NO;
}

- (int)indicesBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate {
	return [Countdown indicesBetweenDate:startDate andDate:endDate forDelay:[[self timeset] delay]];
}

+ (int)indicesBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate forDelay:(int)delay {
	NSDate *ref = [Countdown getReferenceDateForDelay:delay];
	return (int)(([endDate timeIntervalSinceDate:ref]) / delay) - (int)([startDate timeIntervalSinceDate:ref] / delay);
}

+ (NSDate *)getReferenceDateForDelay:(int)delay {
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:1900];
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    return [calendar dateFromComponents:comps];
	switch (delay) {
		case 86400: {
            // Obsolete.
		}
		default:
			return [NSDate dateWithTimeIntervalSince1970:0];
	}
}

- (void)flagDatesFrom:(NSDate *)startDate to:(NSDate *)endDate for:(BinaryArray *)flags {
	int startIndex = [self indexForDate:startDate usingFlags:flags];
	int endIndex = [self indexForDateExclusive:endDate usingFlags:flags];
    CDLog(@"%% Flagging dates from [%@ to %@] [%i to %i].", startDate, endDate, startIndex, endIndex);
	[self flagIndices:flags from:startIndex to:endIndex];
}

- (void)flagIndices:(BinaryArray *)flags from:(int)startIndex to:(int)endIndex {
	for (int i=startIndex; i<=endIndex; i++) {
		[flags setValue:YES atIndex:i];
	}
}

+ (NSUInteger)componentsForUnit:(int)unit {
	NSUInteger rv = NSSecondCalendarUnit;
	if (unit >= 1)
		rv |= NSMinuteCalendarUnit;
	if (unit >= 2)
		rv |= NSHourCalendarUnit;
	if (unit >= 3)
		rv |= NSDayCalendarUnit;
	if (unit >= 4)
		rv |= NSWeekOfYearCalendarUnit;
	if (unit >= 5)
		rv |= NSMonthCalendarUnit;
	if (unit >= 6)
		rv |= NSYearCalendarUnit;
	return rv;
}

+ (NSUInteger)componentForUnit:(int)unit {
	switch (unit) {
		case 0: return NSSecondCalendarUnit;
		case 1: return NSMinuteCalendarUnit;
		case 2: return NSHourCalendarUnit;
		case 3: return NSDayCalendarUnit;
		case 4: return NSWeekOfYearCalendarUnit;
		case 5: return NSMonthCalendarUnit;
		case 6: return NSYearCalendarUnit;
	}
	ERLog(@"[ERROR] componentForUnit did not receive a valid unit.");
	return -42;
}

+ (NSInteger)componentFromComps:(NSDateComponents *)comps withUnit:(int)unit {
	NSUInteger nsunit = [Countdown componentForUnit:unit];
	switch (nsunit) {
		case NSSecondCalendarUnit: return [comps second];
		case NSMinuteCalendarUnit: return [comps minute];
		case NSHourCalendarUnit: return [comps hour];
		case NSDayCalendarUnit: return [comps day];
		case NSWeekOfYearCalendarUnit: return [comps weekOfYear];
		case NSMonthCalendarUnit: return [comps month];
		case NSYearCalendarUnit: return [comps year];
	}
	ERLog(@"[ERROR] componentFromComps did not receive a valid unit.");
	return -42;
}

+ (BOOL)validDate:(NSDateComponents *)comps {
    NSDateComponents *newcomps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:comps]];
    return [comps year] == [newcomps year] && [comps month] == [newcomps month] && [comps day] == [newcomps day] && [comps hour] == [newcomps hour] && [comps minute] == [newcomps minute] && [comps second] == [newcomps second];
}

+ (NSDateComponents *)validateDate:(NSDateComponents *)comps {
    if ([Countdown validDate:comps]) {
        return comps;
    }
    NSDateComponents *newcomps = [calendar components:NSMaxCalendarUnit fromDate:[calendar dateFromComponents:comps]];
    if ([comps month] != [newcomps month]) {
        [newcomps setDay:1];
    }
    return newcomps;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeObject:[self name] forKey:@"name"];
	[encoder encodeObject:[self date] forKey:@"date"];
	[encoder encodeObject:[self timeset] forKey:@"timeset"];
	[encoder encodeInt:[self remainingFlags] forKey:@"remainingFlags"];
	[encoder encodeBool:[self isCountdown] forKey:@"isCountdown"];
	[encoder encodeObject:[self lastUpdate] forKey:@"lastUpdate"];
	[encoder encodeInt:[self unit] forKey:@"unit"];
	[encoder encodeObject:[self elapsed] forKey:@"elapsed"];
	[encoder encodeDouble:[self totalTime] forKey:@"totalTime"];
	[encoder encodeObject:[self displayLong] forKey:@"displayLong"];
	[encoder encodeObject:[self displayShort] forKey:@"displayShort"];
	[encoder encodeObject:[self displayComps] forKey:@"displayComps"];
	[encoder encodeBool:[self calculating] forKey:@"calculating"];
    [encoder encodeBool:[self waiting] forKey:@"waiting"];
	[encoder encodeBool:[self flagAtStartDate] forKey:@"flagAtStartDate"];
	[encoder encodeBool:[self flagAtCurrentDate] forKey:@"flagAtCurrentDate"];
	[encoder encodeInt:[self shouldCancel] forKey:@"shouldCancel"];
	[encoder encodeObject:[self currentSandbox] forKey:@"currentSandbox"];
    [encoder encodeDouble:[self firstHalf] forKey:@"firstHalf"];
    [encoder encodeDouble:[self secondHalf] forKey:@"secondHalf"];
    [encoder encodeObject:[self container] forKey:@"container"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.date = [decoder decodeObjectForKey:@"date"];
		self.timeset = [decoder decodeObjectForKey:@"timeset"];
		self.remainingFlags = [decoder decodeIntForKey:@"remainingFlags"];
		self.isCountdown = [decoder decodeBoolForKey:@"isCountdown"];
		self.lastUpdate = [decoder decodeObjectForKey:@"lastUpdate"];
		self.unit = [decoder decodeIntForKey:@"unit"];
		self.elapsed = [decoder decodeObjectForKey:@"elapsed"];
		self.displayLong = [decoder decodeObjectForKey:@"displayLong"];
		self.displayShort = [decoder decodeObjectForKey:@"displayShort"];
		self.displayComps = [decoder decodeObjectForKey:@"displayComps"];
		self.flagAtStartDate = [decoder decodeBoolForKey:@"flagAtStartDate"];
		self.flagAtCurrentDate = [decoder decodeBoolForKey:@"flagAtCurrentDate"];
		self.calculating = [decoder decodeBoolForKey:@"calculating"];
        self.waiting = [decoder decodeBoolForKey:@"waiting"];
		self.shouldCancel = [decoder decodeIntForKey:@"shouldCancel"];
		self.currentSandbox = [decoder decodeObjectForKey:@"currentSandbox"];
        self.firstHalf = [decoder decodeDoubleForKey:@"firstHalf"];
        self.secondHalf = [decoder decodeDoubleForKey:@"secondHalf"];
        self.container = [decoder decodeObjectForKey:@"container"];
        @try {
            self.totalTime = [decoder decodeDoubleForKey:@"totalTime"];
        }
        @catch (NSException *error) {
            if ([self isCountdown]) {
                [self setupCountdown];
            }
        }
	}
	return self;
}

void dummy(NSString *format, ...) {
	return;
}

void ERLog(NSString *format, ...) {
	va_list args;
	va_start(args, format);
	NSString *formattedString = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@", format] arguments:args];
	va_end(args);
	NSLog(@"%@", formattedString);
}

+ (NSCalendar *)immutableCalendar {
	NSCalendar *noDaylightSavings = [NSCalendar currentCalendar];
	[noDaylightSavings setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[NSTimeZone systemTimeZone] secondsFromGMT]]];
	return noDaylightSavings;
}

@end
