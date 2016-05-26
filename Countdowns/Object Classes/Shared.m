//
//  Singleton.m
//  DateTest
//
//  Created by raxod502 on 4/21/14.
//  Copyright (c) 2014 Raxod502. All rights reserved.
//

#import "Shared.h"

#import "HolidayGen.h"

@implementation Shared

@synthesize countdowns;
@synthesize countups;
@synthesize timesets;

@synthesize currentCountdown;
@synthesize currentTimeset;
@synthesize viewedTimeset;
@synthesize originalTimeset;
@synthesize currentTab;
@synthesize fromCountdowns;
@synthesize skipAppear;

@synthesize holidays;
@synthesize immutableCalendar;
@synthesize bulletlist;
@synthesize datePicker;

+ (id)shared {
    static Shared *shared = nil;
    if (!shared) {
        shared = [self new];
    }
    return shared;
}

+ (void)setShared:(Shared *)new {
    [self setCountdowns:[new countdowns]];
    [self setCountups:[new countups]];
    [self setTimesets:[new timesets]];
    
    [self setCurrentCountdown:[new currentCountdown]];
    [self setCurrentTimeset:[new currentTimeset]];
    [self setViewedTimeset:[new viewedTimeset]];
    [self setOriginalTimeset:[new originalTimeset]];
    [self setCurrentTab:[new currentTab]];
    [self setFromCountdowns:[new fromCountdowns]];
    [self setSkipAppear:[new skipAppear]];
    
    [self setHolidays:[new holidays]];
    [self setImmutableCalendar:[new immutableCalendar]];
    [self setBulletlist:[new bulletlist]];
    [self setDatePicker:[new datePicker]];
}

- (void)reset {
    countdowns = [NSMutableArray new];
    countups = [NSMutableArray new];
    Timeset *none = [[Timeset alloc] initWithName:@"None"];
    [none setInvincible:YES];
    timesets = [NSMutableArray arrayWithObject:none];
    
    currentCountdown = nil;
    currentTimeset = nil;
    viewedTimeset = nil;
    originalTimeset = nil;
    currentTimeset = 0;
    fromCountdowns = YES;
    skipAppear = NO;
    
    holidays = [HolidayGen getHolidays];
    immutableCalendar = [NSCalendar currentCalendar];
    [immutableCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[NSTimeZone systemTimeZone] secondsFromGMT]]];
    bulletlist = [UIImage imageNamed:@"bulletlist.png"];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
}

- (id)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

+ (NSMutableArray *)countdowns { return [[self shared] countdowns]; }
+ (NSMutableArray *)countups { return [[self shared] countups]; }
+ (NSMutableArray *)timesets { return [[self shared] timesets]; }
+ (Countdown *)currentCountdown { return [[self shared] currentCountdown]; }
+ (Timeset *)currentTimeset { return [[self shared] currentTimeset]; }
+ (Timeset *)viewedTimeset { return [[self shared] viewedTimeset]; }
+ (Timeset *)originalTimeset { return [[self shared] originalTimeset]; }
+ (int)currentTab { return [[self shared] currentTab]; }
+ (BOOL)fromCountdowns { return [[self shared] fromCountdowns]; }
+ (BOOL)skipAppear { return [[self shared] skipAppear]; }
+ (NSMutableArray *)holidays { return [[self shared] holidays]; }
+ (NSCalendar *)immutableCalendar { return [[self shared] immutableCalendar]; }
+ (UIImage *)bulletlist { return [[self shared] bulletlist]; }
+ (UIDatePicker *)datePicker { return [[self shared] datePicker]; }

+ (void)setCountdowns:(NSMutableArray *)newCountdowns{ [[self shared] setCountdowns:newCountdowns]; }
+ (void)setCountups:(NSMutableArray *)newCountups{ [[self shared] setCountups:newCountups]; }
+ (void)setTimesets:(NSMutableArray *)newTimesets{ [[self shared] setTimesets:newTimesets]; }
+ (void)setCurrentCountdown:(Countdown *)newCurrentCountdown{ [[self shared] setCurrentCountdown:newCurrentCountdown]; }
+ (void)setCurrentTimeset:(Timeset *)newCurrentTimeset{ [[self shared] setCurrentTimeset:newCurrentTimeset]; }
+ (void)setViewedTimeset:(Timeset *)newViewedTimeset{ [[self shared] setViewedTimeset:newViewedTimeset]; }
+ (void)setOriginalTimeset:(Timeset *)newOriginalTimeset{ [[self shared] setOriginalTimeset:newOriginalTimeset]; }
+ (void)setCurrentTab:(int)newCurrentTab{ [[self shared] setCurrentTab:newCurrentTab]; }
+ (void)setFromCountdowns:(BOOL)newFromCountdowns{ [[self shared] setFromCountdowns:newFromCountdowns]; }
+ (void)setSkipAppear:(BOOL)newSkipAppear{ [[self shared] setSkipAppear:newSkipAppear]; }
+ (void)setHolidays:(NSMutableArray *)newHolidays{ [[self shared] setHolidays:newHolidays]; }
+ (void)setImmutableCalendar:(NSCalendar *)newImmutableCalendar{ [[self shared] setImmutableCalendar:newImmutableCalendar]; }
+ (void)setBulletlist:(UIImage *)newBulletlist{ [[self shared] setBulletlist:newBulletlist]; }
+ (void)setDatePicker:(UIDatePicker *)newDatePicker{ [[self shared] setDatePicker:newDatePicker]; }

// Generated with Python!

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeObject:[self countdowns] forKey:@"countdowns"];
	[encoder encodeObject:[self countups] forKey:@"countups"];
	[encoder encodeObject:[self timesets] forKey:@"timesets"];
    
	[encoder encodeObject:[self currentCountdown] forKey:@"currentCountdown"];
	[encoder encodeObject:[self currentTimeset] forKey:@"currentTimeset"];
	[encoder encodeObject:[self viewedTimeset] forKey:@"viewedTimeset"];
	[encoder encodeObject:[self originalTimeset] forKey:@"originalTimeset"];
	[encoder encodeInt:[self currentTab] forKey:@"currentTab"];
	[encoder encodeBool:[self fromCountdowns] forKey:@"fromCountdowns"];
	[encoder encodeBool:[self skipAppear] forKey:@"skipAppear"];
    
    [encoder encodeObject:[self holidays] forKey:@"holidays"];
	[encoder encodeObject:[self immutableCalendar] forKey:@"immutableCalendar"];
    [encoder encodeObject:[self bulletlist] forKey:@"bulletlist"];
    [encoder encodeObject:[self datePicker] forKey:@"datePicker"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.countdowns = [decoder decodeObjectForKey:@"countdowns"];
		self.countups = [decoder decodeObjectForKey:@"countups"];
		self.timesets = [decoder decodeObjectForKey:@"timesets"];
        
		self.currentCountdown = [decoder decodeObjectForKey:@"currentCountdown"];
		self.currentTimeset = [decoder decodeObjectForKey:@"currentTimeset"];
		self.viewedTimeset = [decoder decodeObjectForKey:@"viewedTimeset"];
		self.originalTimeset = [decoder decodeObjectForKey:@"originalTimeset"];
		self.currentTab = [decoder decodeIntForKey:@"currentTab"];
		self.fromCountdowns = [decoder decodeBoolForKey:@"fromCountdowns"];
		self.skipAppear = [decoder decodeBoolForKey:@"skipAppear"];
        
		self.holidays = [decoder decodeObjectForKey:@"holidays"];
		self.immutableCalendar = [decoder decodeObjectForKey:@"immutableCalendar"];
        self.bulletlist = [decoder decodeObjectForKey:@"bulletlist"];
        self.datePicker = [decoder decodeObjectForKey:@"datePicker"];
	}
	return self;
}

@end
