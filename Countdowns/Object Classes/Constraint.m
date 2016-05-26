//
//  Constraint.m
//  Countdowns
//
//  Created by raxod502 on 6/4/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "Constraint.h"

@implementation Constraint

- (id)init {
	if (self = [super init]) {
		[self setQualifiers:[NSMutableArray array]];
		for (int i=0; i<6; i++) {
			[[self qualifiers] addObject:[[Qualifier alloc] init]];
		}
	}
	return self;
}

- (id)initWithName:(NSString *)name {
	if (self = [self init]) {
		[self setName:name];
	}
	return self;
}

- (void)addQualifier:(Qualifier *)qualifier atIndex:(int)index {
	[[self qualifiers] setObject:qualifier atIndexedSubscript:index];
}

- (NSMutableString *)descriptorForState:(NSString *)state {
	NSMutableString *str = [NSMutableString stringWithString:state];
	int total = 0;
	for (int i=[[self qualifiers] count]-1; i>-1; i--) {
		if ([[[self qualifiers] objectAtIndex:i] group] != NONE) {
			switch (total) {
				case 0:
					[str appendFormat:@" %@", [[[self qualifiers] objectAtIndex:i] descriptorForType:i]];
					break;
				case 1:
					if (i == 3 && [[[self qualifiers] objectAtIndex:i] group] == SPECIFIC_DAY_IN_MONTH && [[[self qualifiers] objectAtIndex:i+1] group] == DAY_OF_WEEK) {
						[str appendFormat:@" %@", [[[self qualifiers] objectAtIndex:i] descriptorForType:i]];
					}
					else {
						[str appendFormat:@" during %@", [[[self qualifiers] objectAtIndex:i] descriptorForType:i]];
					}
					break;
				default: // Could put a , here
					[str appendFormat:@" during %@", [[[self qualifiers] objectAtIndex:i] descriptorForType:i]];
					break;
			}
			total += 1;
		}
	}
	if (total == 0) {
		[str appendString:@" all time."];
	}
	else {
		[str appendString:@"."];
	}
	return str;
}

- (NSMutableString *)descriptor {
	return [self descriptorForState:[self state]];
}

- (id)copyWithZone:(NSZone *)zone {
	Constraint *another = [[Constraint alloc] init];
	[another setState:[[self state] copyWithZone:zone]];
	for (int i=0; i<[[self qualifiers] count]; i++) {
		[another addQualifier:[[[self qualifiers] objectAtIndex:i] copyWithZone:zone] atIndex:i];
	}
	return another;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeObject:[self qualifiers] forKey:@"qualifiers"];
	[encoder encodeObject:[self state] forKey:@"state"];
	[encoder encodeObject:[self name] forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.qualifiers = [decoder decodeObjectForKey:@"qualifiers"];
		self.state = [decoder decodeObjectForKey:@"state"];
		self.name = [decoder decodeObjectForKey:@"name"];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	else {
		Constraint *other = (Constraint *)object;
		return ([[self qualifiers] isEqualToArray:[other qualifiers]] &&
				[[self state] isEqualToString:[other state]] &&
				[[self name] isEqualToString:[other name]]);
	}
}

- (NSUInteger)hash {
	return 42;
}

@end
