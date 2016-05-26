//
//  BinaryArray.h
//  Countdowns
//
//  Created by raxod502 on 6/11/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinaryArray : NSObject

@property int count;
@property int indexCount;
@property unsigned char *values;
@property NSDate *startDate;

- (id)initWithCount:(int)count;
- (id)initWithZerosAndCount:(int)count;
- (id)initWithOnesAndCount:(int)count;
- (BOOL)getValueAtIndex:(int)index;
- (void)setValue:(BOOL)value atIndex:(int)index;
- (void)performNotImpliesWith:(BinaryArray *)other;
- (void)performOrWith:(BinaryArray *)other;
- (void)performAndWith:(BinaryArray *)other;

- (NSString *)description;

- (void)dealloc;

@end
