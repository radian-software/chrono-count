#import <Foundation/Foundation.h>
#import "Countdown.h"

#define c(s) [[Constraint alloc] initWithName:s]

@interface HolidayGen : NSObject

+ (NSMutableArray *)getHolidays;

@end
