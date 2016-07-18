#import <Foundation/Foundation.h>
#import "IntegerArray.h"

@class Sharing;

#define NONE -1
#define SPECIFIC_YEAR 0
#define RANGE_OF_YEARS 1
#define SPECIFIC_MONTH 0
#define RANGE_OF_MONTHS 1
#define SPECIFIC_FULL_WEEK_IN_MONTH 0
#define SPECIFIC_PARTIAL_WEEK_IN_MONTH 1
#define SPECIFIC_DAY_IN_YEAR 0
#define SPECIFIC_DAY_IN_MONTH 1
#define RANGE_OF_DAYS_IN_YEAR 2
#define RANGE_OF_DAYS_IN_MONTH 3
#define DAY_OF_WEEK 0
#define WEEKDAYS 1
#define WEEKENDS 2
#define SPECIFIC_DAY_OF_WEEK_IN_MONTH 3
#define EVERY_OTHER_DAY_OF_WEEK 4
#define RANGE_OF_TIME 0

@interface Qualifier : NSObject <NSCopying, NSCoding>

@property int group;
@property IntegerArray *datums;

- (id)init;
- (id)initWithGroup:(int)group;
- (id)initWithGroup:(int)group datums:(IntegerArray *)datums;
- (void)addDatums:(int)dataPiece;
- (NSString *)descriptorForType:(int)type;
- (NSString *)cardinalStringForInteger:(int)n;
- (id)copyWithZone:(NSZone *)zone;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
