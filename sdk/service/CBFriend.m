#import "CBFriend.h"
#import "NSDictionary+CB.h"


@implementation CBFriend
- (instancetype) initWithUid:(NSString*) uid cubieId:(NSString*) cubieId nickname:(NSString*) nickname iconUrl:(NSString*) iconUrl appInstalled:(BOOL) appInstalled
{
    self = [super init];
    if (self)
    {
        _uid = uid;
        _cubieId = cubieId;
        _nickname = nickname;
        _iconUrl = iconUrl;
        _appInstalled = appInstalled;
    }

    return self;
}

+ (instancetype) decode:(NSDictionary*) raw
{
    return [[self alloc] initWithUid:[raw stringOf:@"uid"]
                             cubieId:[raw stringOf:@"cubie_id"]
                            nickname:[raw stringOf:@"nickname"]
                             iconUrl:[raw stringOf:@"icon_url"]
                        appInstalled:[raw boolOf:@"app_installed"]];

}

- (BOOL) isEqual:(id) other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToAFriend:other];
}

- (BOOL) isEqualToAFriend:(CBFriend*) aFriend
{
    if (self == aFriend)
        return YES;
    if (aFriend == nil)
        return NO;
    if (self.uid != aFriend.uid && ![self.uid isEqualToString:aFriend.uid])
        return NO;
    return YES;
}

- (NSUInteger) hash
{
    return [self.uid hash];
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.uid=%@", self.uid];
    [description appendFormat:@", self.cubieId=%@", self.cubieId];
    [description appendFormat:@", self.nickname=%@", self.nickname];
    [description appendFormat:@", self.iconUrl=%@", self.iconUrl];
    [description appendFormat:@", self.appInstalled=%d", self.appInstalled];
    [description appendString:@">"];
    return description;
}


@end
