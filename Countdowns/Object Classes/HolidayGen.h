//
//  HolidayGen.h
//  Countdowns
//
//  Created by raxod502 on 7/15/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Countdown.h"

#define c(s) [[Constraint alloc] initWithName:s]

@interface HolidayGen : NSObject

+ (NSMutableArray *)getHolidays;

@end
