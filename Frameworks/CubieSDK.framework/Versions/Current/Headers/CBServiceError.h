#import <Foundation/Foundation.h>


@interface CBServiceError : NSError
- (instancetype) initWithReason:(NSString*) reason code:(NSInteger) code;

+ (instancetype) decode:(NSDictionary*) raw;
@end