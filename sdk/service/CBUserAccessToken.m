#import "CBUserAccessToken.h"
#import "NSDictionary+CB.h"


@implementation CBUserAccessToken

- (instancetype) initWithUid:(NSString*) uid appId:(NSString*) appId accessToken:(NSString*) accessToken expireDate:(NSDate*) expireDate
{
    self = [super init];
    if (self)
    {
        _uid = uid;
        _appId = appId;
        _accessToken = accessToken;
        _expireDate = expireDate;
    }

    return self;
}

+ (instancetype) decode:(NSDictionary*) raw
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString* expireDateRaw = [raw stringOf:@"expire_date"];
    NSDate* expireDate = [formatter dateFromString:expireDateRaw];
    return [[self alloc] initWithUid:[raw stringOf:@"uid"]
                               appId:[raw stringOf:@"app_id"]
                         accessToken:[raw stringOf:@"access_token"]
                          expireDate:expireDate];
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"uid=%@", self.uid];
    [description appendFormat:@", appId=%@", self.appId];
    [description appendFormat:@", accessToken=%@", self.accessToken];
    [description appendFormat:@", expireDate=%@", self.expireDate];
    [description appendString:@">"];
    return description;
}


@end
