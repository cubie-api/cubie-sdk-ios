#import <Foundation/Foundation.h>


@interface CBAccessToken : NSObject<NSCoding>
@property (nonatomic, readonly, copy) NSString* uid;
@property (nonatomic, readonly, copy) NSString* openApiAppId;
@property (nonatomic, readonly, copy) NSString* accessToken;
@property (nonatomic, readonly, assign) long long expireTime;

- (instancetype) initWithUid:(NSString*) uid openApiAppId:(NSString*) openApiAppId accessToken:(NSString*) accessToken expireTime:(long long int) expireTime;

- (NSString*) description;

- (id) initWithCoder:(NSCoder*) coder;

- (void) encodeWithCoder:(NSCoder*) coder;

- (BOOL) isValid;

@end
