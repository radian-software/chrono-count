#import "Timeset.h"

@implementation Timeset

- (id)init {
	if (self = [super init]) {
		[self setConstraints:[NSMutableArray new]];
		[self setInvincible:NO];
		[self findDelay];
	}
	return self;
}

- (id)initWithName:(NSString *)newName {
	if (self = [super init]) {
		[self setName:newName];
		[self setConstraints:[NSMutableArray new]];
		[self setInvincible:NO];
		[self findDelay];
	}
	return self;
}

- (id)initWithName:(NSString *)newName withConstraint:(Constraint *)constraint {
	if (self = [super init]) {
		[self setName:newName];
		[self setConstraints:[NSMutableArray arrayWithObject:constraint]];
		[self setInvincible:NO];
		[self findDelay];
	}
	return self;
}

- (id)initWithName:(NSString *)newName withConstraints:(NSMutableArray *)newConstraints {
	if (self = [super init]) {
		[self setName:newName];
		[self setConstraints:newConstraints];
		[self setInvincible:NO];
		[self findDelay];
	}
	return self;
}

- (void)addConstraint:(Constraint *)constraint {
	[[self constraints] addObject:constraint];
	[self findDelay];
}

- (void)removeConstraint:(Constraint *)constraint {
	[[self constraints] removeObject:constraint];
	[self findDelay];
}

- (void)removeConstraintAtIndex:(NSUInteger)index {
	[[self constraints] removeObjectAtIndex:index];
	[self findDelay];
}

- (id)copyWithZone:(NSZone *)zone {
	NSMutableArray *copyArray = [[self constraints] copyWithZone:zone];
	NSMutableArray *newArray = [NSMutableArray new];
	for (Constraint *constraint in copyArray) {
		[newArray addObject:constraint];
	}
	
	Timeset *another = [[Timeset alloc] initWithName:[[self name] copyWithZone:zone] withConstraints:newArray];
	return another;
}

- (void)findDelay {
	[self setDelay:86401];
	for (Constraint *constraint in [self constraints]) {
		if ([[[constraint qualifiers] objectAtIndex:5] group] != NONE) {
			Qualifier *qualifier = [[constraint qualifiers] objectAtIndex:5];
			if ([[qualifier datums] integerAtIndex:1]%12 != 0 || [[qualifier datums] integerAtIndex:3]%12 != 0) {
				if ([[qualifier datums] integerAtIndex:1]%3 != 0 || [[qualifier datums] integerAtIndex:3]%3 != 0) {
					[self setDelay:300];
				}
				else if ([self delay] > 900) {
					[self setDelay:900];
				}
			}
			else if ([self delay] > 3600) {
				[self setDelay:3600];
			}
		}
		else if ([self delay] > 86400) {
			[self setDelay:86400];
		}
	}
	if ([self delay] == 86401) {
		[self setDelay:86400];
	}
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeObject:[self name] forKey:@"name"];
	[encoder encodeObject:[self constraints] forKey:@"constraints"];
	[encoder encodeBool:[self invincible] forKey:@"invincible"];
	[encoder encodeBool:[self viewed] forKey:@"viewed"];
	[encoder encodeInt:[self delay] forKey:@"delay"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.constraints = [decoder decodeObjectForKey:@"constraints"];
		self.invincible = [decoder decodeBoolForKey:@"invincible"];
		self.viewed = [decoder decodeBoolForKey:@"viewed"];
		self.delay = [decoder decodeIntForKey:@"delay"];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	else {
		Timeset *other = (Timeset *)object;
		return ([[self name] isEqualToString:[other name]] &&
				[[self constraints] isEqualToArray:[other constraints]] &&
				[self invincible] == [other invincible]);
	}
}

- (NSUInteger)hash {
	return 42; // Because I'm lazy. Deal with it.
}

@end
