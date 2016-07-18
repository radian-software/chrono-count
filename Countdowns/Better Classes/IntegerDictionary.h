#import <Foundation/Foundation.h>

@interface IntegerDictionary : NSObject

@property NSMutableDictionary *dict;

+ (id)dictionary;
- (void)setInteger:(int)anInteger forKey:(int)aKey;
- (int)integerForKey:(int)aKey;

@end
