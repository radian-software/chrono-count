#import "HolidayGen.h"

@implementation HolidayGen

+ (NSMutableArray *)getHolidays {
	Constraint *newyears = c(@"New Year's Day");
	[newyears addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:0, 0, END]] atIndex:3];
	Constraint *mlkday = c(@"Martin Luther King Day");
	[mlkday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 2, END]] atIndex:4];
	[mlkday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:0, END]] atIndex:1];
	Constraint *washington = c(@"Presidents' Day");
	[washington addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 2, END]] atIndex:4];
	[washington addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:1, END]] atIndex:1];
	Constraint *memorial = c(@"Memorial Day");
	[memorial addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 5, END]] atIndex:4];
	[memorial addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:5, END]] atIndex:1];
	Constraint *independence = c(@"Independence Day");
	[independence addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:6, 3, END]] atIndex:3];
	Constraint *laborday = c(@"Labor Day");
	[laborday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 0, END]] atIndex:4];
	[laborday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:8, END]] atIndex:1];
	Constraint *columbus = c(@"Columbus Day");
	[columbus addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 1, END]] atIndex:4];
	[columbus addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:9, END]] atIndex:1];
	Constraint *veterans = c(@"Veterans' Day");
	[veterans addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:10, 10, END]] atIndex:3];
	Constraint *thanksgiving = c(@"Thanksgiving");
	[thanksgiving addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:4, 3, END]] atIndex:4];
	[thanksgiving addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:10, END]] atIndex:1];
	Constraint *christmas = c(@"Christmas");
	[christmas addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:11, 24, END]] atIndex:3];
	Constraint *groundhog = c(@"Groundhog Day");
	[groundhog addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:1, 1, END]] atIndex:3];
	Constraint *valentines = c(@"Valentine's Day");
	[valentines addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:1, 13, END]] atIndex:3];
	Constraint *earthday = c(@"Earth Day");
	[earthday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:3, 21, END]] atIndex:3];
	Constraint *arborday = c(@"Arbor Day");
	[arborday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:5, 5, END]] atIndex:4];
	[arborday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:3, END]] atIndex:1];
	Constraint *mothersday = c(@"Mother's Day");
	[mothersday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:0, 1, END]] atIndex:4];
	[mothersday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:4, END]] atIndex:1];
	Constraint *flagday = c(@"Flag Day");
	[flagday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:5, 13, END]] atIndex:3];
	Constraint *fathersday = c(@"Father's Day");
	[fathersday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:0, 2, END]] atIndex:4];
	[fathersday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:5, END]] atIndex:1];
	Constraint *patriotday = c(@"Patriot Day (9/11)");
	[patriotday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:8, 10, END]] atIndex:3];
	Constraint *patriotsday = c(@"Patriots' Day (April)");
	[patriotsday addQualifier:[[Qualifier alloc] initWithGroup:3 datums:[IntegerArray arrayWithIntegers:1, 2, END]] atIndex:4];
	[patriotsday addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:3, END]] atIndex:1];
	Constraint *halloween = c(@"Halloween");
	[halloween addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:9, 30, END]] atIndex:3];
	Constraint *pearlharbor = c(@"Pearl Harbor Day");
	[pearlharbor addQualifier:[[Qualifier alloc] initWithGroup:0 datums:[IntegerArray arrayWithIntegers:11, 6, END]] atIndex:3];
	NSArray *unsorted = @[newyears, mlkday, washington, independence, laborday, columbus, veterans, thanksgiving, christmas, groundhog, valentines, earthday, arborday, mothersday, flagday, fathersday, patriotday, patriotsday, halloween, pearlharbor];
    NSMutableArray *sorted = [NSMutableArray arrayWithArray:[unsorted sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]]];
	return sorted;
}

@end
