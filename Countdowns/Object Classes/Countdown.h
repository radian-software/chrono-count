//
//  Countdown.h
//  Countdowns
//
//  Created by raxod502 on 6/3/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <mach/mach.h>
#import <mach/processor_info.h>
#import <mach/mach_host.h>

#import "Timeset.h"
#import "BinaryArray.h"

@class CountdownDetailViewController;
@class CountupDetailViewController;

#define CDLog dummy
#define CDLog2 dummy
#define CDLogF dummy

//#define getOffset [Shared offset]
#define getOffset 0

#define calendar [Shared immutableCalendar]
//#define today [NSDate dateWithTimeIntervalSince1970:round([[NSDate date] timeIntervalSince1970])]
//#define nowdate [NSDate date]
#define today [NSDate dateWithTimeIntervalSince1970:round([[NSDate date] timeIntervalSince1970]) + getOffset]
#define nowdate [NSDate dateWithTimeInterval:getOffset sinceDate:[NSDate date]]
#define realdate [NSDate date]
#define INTERVAL 0
#define SETUPDELAY 0.4
#define TABLEDELAY 0
#define NSMaxCalendarUnit NSUIntegerMax ^ NSYearForWeekOfYearCalendarUnit
#define plural(n) n == 1 ? @"" : @"s"
#define sort(array, earlyfirst) [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:earlyfirst]]]

#define CELLSIZE 44
#define UNIT_DISPLAY @[@"Second", @"Minute", @"Hour", @"Day", @"Week", @"Month", @"Year"]

#define CDOWN_RECALC @"This countdown is being recalculated..."
#define CUP_RECALC @"This countup is being recalculated..."
#define CDOWN_RECALC_LONG @"This countdown is being recalculated...\n\n\n\n\n\n\n\n\n\nYou may continue to view other\ncountdowns while this task is finished."
#define CUP_RECALC_LONG @"This countup is being recalculated...\n\n\n\n\n\n\n\n\n\nYou may continue to view other\ncountups while this task is finished."

#define form(date) [date debugDescription]

#define GOOD YES
#define BAD NO
#define or ||
#define and &&
#define not !

@class CountupDetailViewController;
@class CountdownDetailViewController;

@interface Countdown : NSObject <NSCoding>

@property NSString *name;
@property NSDate *date;
@property Timeset *timeset;
@property NSDate *lastUpdate;
@property Countdown *elapsed;
@property NSString *displayLong;
@property NSString *displayShort;
@property NSDateComponents *displayComps;
@property Countdown *currentSandbox;
@property Countdown *container;
@property NSTimer *repeatTimer;
@property int remainingFlags;
@property BOOL isCountdown;
@property int unit;
@property float totalTime;
@property BOOL flagAtStartDate;
@property BOOL flagAtCurrentDate;
@property int shouldCancel;
@property double firstHalf;
@property double secondHalf;
@property BOOL calculating;
@property BOOL waiting;
@property BOOL finishedSetup;

- (id)initWithName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset;
- (id)initCountupWithName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset;
- (id)initCountupWithNoSetupAndName:(NSString *)name date:(NSDate *)date timeset:(Timeset *)timeset;

- (void)kill;
- (void)unkill;
+ (NSString *)stringForDate:(NSDate *)date;
- (void)setupCountdown;
- (void)setupCountup;
- (void)doRepeatCountdownInBackground:(NSTimer *)theTimer;
- (void)doRepeatCountupInBackground:(NSTimer *)theTimer;
- (void)repeatSetupCountdown:(NSTimer *)timer;
- (void)repeatSetupCountup:(NSTimer *)timer;
- (void)coreSetupCountdown;
- (void)coreSetupCountup;
- (void)createCountdownFlags;
- (void)resetCountupFlags;
- (double)createCountdownTimeFrom:(NSDate *)startDate to:(NSDate *)endDate;
- (double)calculateCountdownTime;
- (void)updateCountdown;
- (void)updateCountup;
- (double)realUpdateCountdown;
- (double)realUpdateCountup;
- (double)updateCountupWithToday:(NSDate *)now;
- (void)verifyUnits;

- (BinaryArray *)coreCalculateFrom:(NSDate *)startDate to:(NSDate *)endDate;
- (int)calculateFlagsFrom:(NSDate *)startDate to:(NSDate *)endDate;
- (int)updateFlagsFrom:(NSDate *)startDate to:(NSDate *)endDate;
- (BOOL)shouldAddHourForDaylightSavingsTransitionAt:(NSDate *)date;
- (BOOL)checkFlagAt:(NSDate *)date;

- (void)performQualifier:(Qualifier *)qualifier ofType:(int)type onFlags:(BinaryArray *)flags fromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

- (int)indexForDate:(NSDate *)date usingFlags:(BinaryArray *)flags;
- (int)indexForDateExclusive:(NSDate *)date usingFlags:(BinaryArray *)flags;
- (BOOL)cuspOffsetForDate:(NSDate *)date;
- (BOOL)offsetForDate:(NSDate *)date;
- (int)indicesBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate;
+ (int)indicesBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate forDelay:(int)delay;
+ (NSDate *)getReferenceDateForDelay:(int)delay;

- (void)flagDatesFrom:(NSDate *)startDate to:(NSDate *)endDate for:(BinaryArray *)flags; // Hahahahahahahahaha I used a keyword in my function hahahahahahahaha
- (void)flagIndices:(BinaryArray *)flags from:(int)startIndex to:(int)endIndex;

+ (NSUInteger)componentsForUnit:(int)unit;
+ (NSUInteger)componentForUnit:(int)unit;
+ (NSInteger)componentFromComps:(NSDateComponents *)comps withUnit:(int)unit;
+ (BOOL)validDate:(NSDateComponents *)comps;
+ (NSDateComponents *)validateDate:(NSDateComponents *)comps;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

void dummy(NSString *format, ...);
void ERLog(NSString *format, ...);

+ (NSCalendar *)immutableCalendar;

@end
