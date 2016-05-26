//
//  IntegerDictionary.m
//  Countdowns
//
//  Created by raxod502 on 6/8/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "IntegerDictionary.h"

@implementation IntegerDictionary

+ (id)dictionary {
	IntegerDictionary *instance = [[IntegerDictionary alloc] init];
	[instance setDict:[NSMutableDictionary dictionary]];
	return instance;
}

- (void)setInteger:(int)anInteger forKey:(int)aKey {
	[[self dict] setObject:[NSNumber numberWithInt:anInteger] forKey:[NSNumber numberWithInt:aKey]];
}

- (int)integerForKey:(int)aKey {
	return [[[self dict] objectForKey:[NSNumber numberWithInt:aKey]] intValue];
}

@end
