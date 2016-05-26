//
//  IntegerDictionary.h
//  Countdowns
//
//  Created by raxod502 on 6/8/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegerDictionary : NSObject

@property NSMutableDictionary *dict;

+ (id)dictionary;
- (void)setInteger:(int)anInteger forKey:(int)aKey;
- (int)integerForKey:(int)aKey;

@end
