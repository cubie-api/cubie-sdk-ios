#import "Cubie.h"
#import "CBPref.h"
#import "NSURL+CB.h"
#import "NSDictionary+CB.h"
#import "CBAccessToken.h"
#import "CBSession.h"


@implementation Cubie

+ (NSURL*) connectUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"cubie://connect?appKey=%@&appUniqueDeviceId=%@",
                                                           [Cubie appKey],
                                                           [Cubie appUniqueDeviceId]]];
}

+ (NSURL*) disconnectUrl:(NSString*) uid
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"cubie://disconnect?appKey=%@&appUniqueDeviceId=%@&uid=%@",
                                                           [Cubie appKey],
                                                           [Cubie appUniqueDeviceId],
                                                           uid]];
}

+ (NSString*) appKey
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CubieAppKey"];
}

+ (NSString*) appUniqueDeviceId
{
    NSString* appUniqueDeviceId = [CBPref load:@"appUniqueDeviceId"];
    if (!appUniqueDeviceId)
    {
        appUniqueDeviceId = [[NSUUID UUID] UUIDString];
        [CBPref store:@"appUniqueDeviceId" value:appUniqueDeviceId];
    }
    return appUniqueDeviceId;
}

+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication
{
    if (![sourceApplication isEqualToString:@"com.liquable.nemo"])
    {
        return NO;
    }

    if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"cubie-%@://connect", [Cubie appKey]]])
    {
        NSDictionary* resultParams = [url decodeParameters];
        CBAccessToken* accessToken = [[CBAccessToken alloc] initWithUid:[resultParams stringOf:@"uid"]
                                                           openApiAppId:[resultParams stringOf:@"openApiAppId"]
                                                            accessToken:[resultParams stringOf:@"accessToken"]
                                                             expireTime:[resultParams longLongOf:@"expireTime"]];
        if ([accessToken isValid])
        {
            if (![CBSession getSession])
            {
                [CBSession init:nil];
            }
            [[CBSession getSession] finishConnect:accessToken];
        }
        return YES;
    } else if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"cubie-%@://disconnect", [Cubie appKey]]])
    {
        if ([CBSession getSession])
        {
            [[CBSession getSession] finishDisconnect];
        }
        return YES;
    }
    return NO;
}

@end
