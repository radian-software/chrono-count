//
//  BinaryArray.m
//  Countdowns
//
//  Created by raxod502 on 6/11/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "BinaryArray.h"

@implementation BinaryArray

- (id)initWithCount:(int)count {
	if (self = [super init]) {
		if (count <= 0) {
			return nil;
		}
		[self setCount:count];
        [self setIndexCount:count/8];
        if (count%8 != 0) [self setIndexCount:[self indexCount]+1];
        
        [self setValues:malloc(sizeof(unsigned char)*[self indexCount])];
	}
	return self;
}

- (id)initWithZerosAndCount:(int)count {
	if (self = [super init]) {
		if (count <= 0) {
			return nil;
		}
		[self setCount:count];
        [self setIndexCount:count/8];
        if (count%8 != 0) [self setIndexCount:[self indexCount]+1];
        
        [self setValues:malloc(sizeof(unsigned char)*[self indexCount])];
        for (int i=0; i<[self indexCount]; i++) {
            [self values][i] = 0;
        }
	}
	return self;
}

- (id)initWithOnesAndCount:(int)count {
	if (self = [super init]) {
		if (count <= 0) {
			return nil;
		}
		[self setCount:count];
        [self setIndexCount:count/8];
        if (count%8 != 0) [self setIndexCount:[self indexCount]+1];
        
        [self setValues:malloc(sizeof(unsigned char)*[self indexCount])];
        for (int i=0; i<[self indexCount]; i++) {
            [self values][i] = 255;
        }
	}
	return self;
}

- (BOOL)getValueAtIndex:(int)index {
	if (index < 0 || index >= [self count]) {
		return -1;
	}
	return ([self values][index/8] & (1 << index%8)) != 0;
}

- (void)setValue:(BOOL)value atIndex:(int)index {
	value = value != 0;
	if (index < 0 || index >= [self count]) {
		return;
	}
	if (value != [self getValueAtIndex:index]) {
		[self values][index/8] ^= (1 << index%8);
	}
}

- (void)performNotImpliesWith:(BinaryArray *)other {
    for (int i=0; i<[self indexCount]; i++) {
        [self values][i] = [self values][i] & ~[other values][i];
    }
}

- (void)performOrWith:(BinaryArray *)other {
    for (int i=0; i<[self indexCount]; i++) {
        [self values][i] = [self values][i] | [other values][i];
    }
}

- (void)performAndWith:(BinaryArray *)other {
    for (int i=0; i<[self indexCount]; i++) {
        [self values][i] = [self values][i] & [other values][i];
    }
}

- (NSString *)description {
	NSMutableString *str = [NSMutableString stringWithString:@"{"];
	for (int i=0; i<[self count]-1; i++) {
		[str appendFormat:@"%i, ", [self getValueAtIndex:i]];
	}
	[str appendFormat:@"%i}", [self getValueAtIndex:[self count]-1]];
	return str;
}

- (void)dealloc {
	free([self values]);
}

@end
