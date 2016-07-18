#import "IntegerArray.h"

@implementation IntegerArray

+ (id)array {
	IntegerArray *instance = [[IntegerArray alloc] init];
	return instance;
}

+ (id)arrayWithIntegers:(int)firstObj, ... {
	va_list args;
	IntegerArray *instance = [[IntegerArray alloc] init];
	[instance addInteger:firstObj];
	va_start(args, firstObj);
	int object;
	while ((object = va_arg(args, int)) != END) {
		[instance addInteger:object];
	}
	return instance;
}

+ (id)arrayWithTechnicalArray:(NSMutableArray *)array {
	IntegerArray *instance = [[IntegerArray alloc] init];
	[instance setList:array];
	return instance;
}

- (id)init {
	if (self = [super init]) {
		[self setList:[NSMutableArray array]];
	}
	return self;
}

- (void)setInteger:(int)obj atIndexedSubscript:(NSUInteger)idx {
	[[self list] setObject:[NSNumber numberWithInt:obj] atIndexedSubscript:idx];
}

- (int)integerAtIndex:(NSUInteger)index {
	return [[[self list] objectAtIndex:index] intValue];
}

- (void)addInteger:(int)obj {
	[[self list] addObject:[NSNumber numberWithInt:obj]];
}

- (NSUInteger)count {
	return [[self list] count];
}

- (id)copyWithZone:(NSZone *)zone {
	IntegerArray *another = [IntegerArray arrayWithTechnicalArray:[[self list] copyWithZone:zone]];
	return another;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSCoder *encoder = aCoder;
	[encoder encodeObject:[self list] forKey:@"list"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSCoder *decoder = aDecoder;
	if (self = [super init]) {
		self.list = [decoder decodeObjectForKey:@"list"];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) {
		return NO;
	}
	else {
		IntegerArray *other = (IntegerArray *)object;
		return [[self list] isEqualToArray:[other list]];
	}
}

- (NSUInteger)hash {
	return 42;
}

@end
