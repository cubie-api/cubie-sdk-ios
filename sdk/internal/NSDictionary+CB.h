#import <Foundation/Foundation.h>

@interface NSDictionary(CB)

- (NSString*) stringOf:(id) key;

- (int) intOf:(id) key;

- (NSInteger) integerOf:(id) key;

- (long long) longLongOf:(id) key;

- (double) doubleOf:(id) key;

- (NSArray*) arrayOf:(id) key;

- (NSDictionary*) dictionaryOf:(id) key;

- (BOOL) boolOf:(id) key;

/**
 * return nil if value is [NSNull null]
 */
- (id) objectOf:(id) key;

@end
