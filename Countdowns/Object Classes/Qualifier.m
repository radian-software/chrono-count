#import "Qualifier.h"

@implementation Qualifier

- (id)init {
	if (self = [super init]) {
		[self setGroup:NONE];
		[self setDatums:[IntegerArray array]];
	}
	return self;
}

- (id)initWithGroup:(int)group {
	if (self = [super init]) {
		[self setGroup:group];
		[self setDatums:[IntegerArray array]];
	}
	return self;
}

- (id)initWithGroup:(int)group datums:(IntegerArray *)datums {
	if (self = [super init]) {
		[self setGroup:group];
		[self setDatums:datums];
	}
	return self;
}

- (void)addDatums:(int)datumsPiece {
	[[self datums] addInteger:datumsPiece];
}

- (NSString *)descriptorForType:(int)type {
	NSArray *months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
	NSArray *weeks = @[@"first", @"second", @"third", @"fourth", @"fifth", @"last"];
	NSArray *weekdays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
	switch (type) {
		case 0:
			switch ([self group]) {
				case NONE:
					return @"every year";
				case SPECIFIC_YEAR:
					return [NSString stringWithFormat:@"%i", [[self datums] integerAtIndex:0]];
				case RANGE_OF_YEARS:
					return [NSString stringWithFormat:@"%i through %i", [[self datums] integerAtIndex:0], [[self datums] integerAtIndex:1]];
			}
			break;
		case 1:
			switch ([self group]) {
				case NONE:
					return @"every month";
				case SPECIFIC_MONTH:
					return [months objectAtIndex:[[self datums] integerAtIndex:0]];
				case RANGE_OF_MONTHS:
					return [NSString stringWithFormat:@"%@ through %@", [months objectAtIndex:[[self datums] integerAtIndex:0]], [months objectAtIndex:[[self datums] integerAtIndex:1]]];
			}
			break;
		case 2:
			switch ([self group]) {
				case NONE:
					return @"[INVALID]";
				case 0: {
					return [[[Shared holidays] objectAtIndex:[[self datums] integerAtIndex:0]] name];
				}
			}
			break;
		case 3:
			switch ([self group]) {
				case NONE:
					return @"every day";
				case SPECIFIC_DAY_IN_YEAR:
					return [NSString stringWithFormat:@"%@ %i", [months objectAtIndex:[[self datums] integerAtIndex:0]], [[self datums] integerAtIndex:1]+1];
				case SPECIFIC_DAY_IN_MONTH:
					return [NSString stringWithFormat:@"the %i%@", [[self datums] integerAtIndex:0]+1, [self cardinalStringForInteger:[[self datums] integerAtIndex:0]+1]];
				case RANGE_OF_DAYS_IN_YEAR:
					return [NSString stringWithFormat:@"%@ %i through %@ %i", [months objectAtIndex:[[self datums] integerAtIndex:0]], [[self datums] integerAtIndex:1]+1, [months objectAtIndex:[[self datums] integerAtIndex:2]], [[self datums] integerAtIndex:3]+1];
				case RANGE_OF_DAYS_IN_MONTH:
					return [NSString stringWithFormat:@"the %i%@ through the %i%@", [[self datums] integerAtIndex:0]+1, [self cardinalStringForInteger:[[self datums] integerAtIndex:0]+1], [[self datums] integerAtIndex:1]+1, [self cardinalStringForInteger:[[self datums] integerAtIndex:1]+1]];
			}
			break;
		case 4:
			switch ([self group]) {
				case NONE:
					return @"all week";
				case DAY_OF_WEEK:
					return [weekdays objectAtIndex:[[self datums] integerAtIndex:0]];
				case WEEKDAYS:
					return @"weekdays";
				case WEEKENDS:
					return @"weekends";
				case SPECIFIC_DAY_OF_WEEK_IN_MONTH:
					return [NSString stringWithFormat:@"the %@ %@", [weeks objectAtIndex:[[self datums] integerAtIndex:1]], [weekdays objectAtIndex:[[self datums] integerAtIndex:0]]];
				case EVERY_OTHER_DAY_OF_WEEK:
					return [NSString stringWithFormat:@"every other %@, starting on %@", [weekdays objectAtIndex:[[self datums] integerAtIndex:0]], [NSString stringWithFormat:@"%@ %i, %i", [months objectAtIndex:[[self datums] integerAtIndex:1]], [[self datums] integerAtIndex:2]+1, [[self datums] integerAtIndex:3]]];
			}
			break;
		case 5:
			switch ([self group]) {
				case NONE:
					return @"all hours";
				case RANGE_OF_TIME: {
					int index0 = [[self datums] integerAtIndex:0]-1;
					if (index0 == -1) index0 = 23;
					int index1 = [[self datums] integerAtIndex:1];
					int index2 = [[self datums] integerAtIndex:2]-1;
					if (index2 == -1) index2 = 23;
					int index3 = [[self datums] integerAtIndex:3];
					return [NSString stringWithFormat:@"%@ through %@", (index0 == -1 || index0 == 11) && index1 == 0 ? (index0+1 == 12 ? @"noon" : @"12:00 AM") : [NSString stringWithFormat:@"%i:%.2i %@", index0%12+1, index1*5, index0>=11 && index0 != 23 ? @"PM" : @"AM"], (index2 == -1 || index2 == 11) && index3 == 0 ? (index2+1 == 12 ? @"noon" : @"12:00 AM") : [NSString stringWithFormat:@"%i:%.2i %@", index2%12+1, index3*5, index2>=11 && index2 != 23 ? @"PM" : @"AM"]];
				}
			}
			break;
	}
	return @"[UNDEFINED]";
}

- (NSString *)cardinalStringForInteger:(int)n {
	if (n%10 == 1 && n%100 != 11) {
		return @"st";
	}
	else if (n%10 == 2 && n%100 != 12) {
		return @"nd";
	}
	else if (n%10 == 3 && n%100 != 13) {
		return @"rd";
	}
	else {
		return @"th";
	}
}

- (id)copyWithZone:(NSZone *)zone {
	Qualifier *another = [[Qualifier alloc] initWithGroup:[self group] datums:[[self datums] copyWithZone:zone]];
	return another;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeInt:[self group] forKey:@"group"];
	[encoder encodeObject:[self datums] forKey:@"datums"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.group = [decoder decodeIntForKey:@"group"];
		self.datums = [decoder decodeObjectForKey:@"datums"];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	else {
		Qualifier *other = (Qualifier *)object;
		return ([self group] == [other group] &&
				[[self datums] isEqual:[other datums]]);
	}
}

- (NSUInteger)hash {
	return 42;
}

@end
