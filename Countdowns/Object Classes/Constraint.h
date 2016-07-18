#import "Qualifier.h"

@interface Constraint : NSObject <NSCopying, NSCoding>

@property NSMutableArray *qualifiers;
@property NSString *state; // Not optional at all :(
@property NSString *name; // Optional! :D

- (id)init;
- (id)initWithName:(NSString *)name;
- (void)addQualifier:(Qualifier *)qualifier atIndex:(int)index;
- (NSMutableString *)descriptorForState:(NSString *)state;
- (NSMutableString *)descriptor;
- (id)copyWithZone:(NSZone *)zone;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
