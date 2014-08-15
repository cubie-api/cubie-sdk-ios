#import <Foundation/Foundation.h>


@interface CBUserAccessToken : NSObject
@property (nonatomic, readonly, copy) NSString* uid;
@property (nonatomic, readonly, copy) NSString* appId;
@property (nonatomic, readonly, copy) NSString* accessToken;
@property (nonatomic, readonly, strong) NSDate* expireDate;

- (instancetype) initWithUid:(NSString*) uid appId:(NSString*) appId accessToken:(NSString*) accessToken expireDate:(NSDate*) expireDate;

+ (instancetype) decode:(NSDictionary*) raw;

@end
