#import "CBAccessToken.h"


@implementation CBAccessToken

- (instancetype) initWithUid:(NSString*) uid openApiAppId:(NSString*) openApiAppId accessToken:(NSString*) accessToken expireTime:(long long int) expireTime
{
    self = [super init];
    if (self)
    {
        _uid = uid;
        _openApiAppId = openApiAppId;
        _accessToken = accessToken;
        _expireTime = expireTime;
    }

    return self;
}

- (BOOL) isValid
{
    return self.uid && self.uid.length > 0
      && self.openApiAppId && self.openApiAppId.length > 0
      && self.accessToken && self.accessToken.length > 0
      && self.expireTime > [[NSDate date] timeIntervalSince1970] * 1000;
}

- (id) initWithCoder:(NSCoder*) coder
{
    return [self initWithUid:[coder decodeObjectForKey:@"self.uid"]
                openApiAppId:[coder decodeObjectForKey:@"self.openApiAppId"]
                 accessToken:[coder decodeObjectForKey:@"self.accessToken"]
                  expireTime:[coder decodeInt64ForKey:@"self.expireTime"]];
}

- (void) encodeWithCoder:(NSCoder*) coder
{
    [coder encodeObject:self.uid forKey:@"self.uid"];
    [coder encodeObject:self.openApiAppId forKey:@"self.openApiAppId"];
    [coder encodeObject:self.accessToken forKey:@"self.accessToken"];
    [coder encodeInt64:self.expireTime forKey:@"self.expireTime"];
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"uid=%@", self.uid];
    [description appendFormat:@", openApiAppId=%@", self.openApiAppId];
    [description appendFormat:@", accessToken=%@", self.accessToken];
    [description appendFormat:@", expireTime=%qi", self.expireTime];
    [description appendString:@">"];
    return description;
}

@end
