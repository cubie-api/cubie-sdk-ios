#import <Foundation/Foundation.h>

@class CBAccessToken;
@class CBPref;

@interface CBSession : NSObject

typedef void (^SessionCallback)(CBSession* session);

+ (CBSession*) getSession;

+ (void) init:(SessionCallback) callback;

- (void) open:(SessionCallback) callback;

- (void) close:(SessionCallback) callback;

- (void) close;

- (void) finishConnect:(CBAccessToken*) accessToken;

- (void) finishDisconnect;

- (BOOL) isOpen;

- (long long) getExpireTime;

- (NSString*) getAccessToken;

- (void) testMakeAccessTokenNeedToRefresh;

- (void) testInvalidAccessToken;

@end
