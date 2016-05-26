//
//  Constraint.h
//  Countdowns
//
//  Created by raxod502 on 6/4/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

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
