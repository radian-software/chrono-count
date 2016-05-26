//
//  IntegerArray.h
//  Countdowns
//
//  Created by raxod502 on 6/8/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <Foundation/Foundation.h>

#define END -51

@interface IntegerArray : NSObject <NSCopying, NSCoding>

@property NSMutableArray *list;

+ (id)array;
+ (id)arrayWithIntegers:(int)firstObj, ...;
+ (id)arrayWithTechnicalArray:(NSMutableArray *)array;
- (id)init;
- (void)setInteger:(int)obj atIndexedSubscript:(NSUInteger)idx;
- (int)integerAtIndex:(NSUInteger)index;
- (void)addInteger:(int)obj;
- (NSUInteger)count;
- (id)copyWithZone:(NSZone *)zone;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
