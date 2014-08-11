#import <Foundation/Foundation.h>

@class CBAccessToken;


@interface CBPref : NSObject

+ (void) storeAccessToken:(CBAccessToken*) accessToken;

+ (CBAccessToken*) loadAccessToken;

+ (void) clearAccessToken;

+ (id) load:(NSString*) key;

+ (void) store:(NSString*) key value:(id) value;

@end
