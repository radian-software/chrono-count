#import <Foundation/Foundation.h>
#import "Timeset.h"
#import "Constraint.h"

@interface Timeset : NSObject <NSCopying, NSCoding>

@property NSString *name;
@property NSMutableArray *constraints;
@property BOOL invincible;
@property BOOL viewed;
@property int delay;

- (id)init;
- (id)initWithName:(NSString *)newName;
- (id)initWithName:(NSString *)newName withConstraint:(Constraint *)constraint;
- (id)initWithName:(NSString *)newName withConstraints:(NSMutableArray *)newConstraints;
- (void)addConstraint:(Constraint *)constraint;
- (void)removeConstraint:(Constraint *)constraint;
- (void)removeConstraintAtIndex:(NSUInteger)index;
- (id)copyWithZone:(NSZone *)zone;
- (void)findDelay;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
