#import <UIKit/UIKit.h>
#import "Cubie.h"
#import "CBPref.h"
#import "NSURL+CB.h"
#import "NSDictionary+CB.h"
#import "CBAccessToken.h"
#import "CBSession.h"
#import "UIImage+CB.h"

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

+ (UIButton*) buttonWithCubieStyle
{
    UIButton* connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString* pathForCBResources = [[NSBundle mainBundle] pathForResource:@"CBResources" ofType:@"bundle"];
    NSBundle* CBResources = [NSBundle bundleWithPath:pathForCBResources];
    [connectButton setTitle:[CBResources localizedStringForKey:@"connect_with_cubie" value:@"Connect with Cubie"
                                                         table:nil]
                   forState:UIControlStateNormal];
    [connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connectButton setImage:[UIImage imageWithContentsOfFile:[CBResources pathForResource:@"cubie_icon" ofType:@"png"]]
                   forState:UIControlStateNormal];
    [connectButton setImage:[UIImage imageWithContentsOfFile:[CBResources pathForResource:@"cubie_icon" ofType:@"png"]]
                   forState:UIControlStateHighlighted];
    [connectButton setBackgroundImage:[UIImage stretchableImageWithColor:[UIColor colorWithRed:0.153 green:0.725
                                                                                          blue:0.698 alpha:1]]
                             forState:UIControlStateNormal];
    [connectButton setBackgroundImage:[UIImage stretchableImageWithColor:[UIColor colorWithRed:0.176 green:0.831
                                                                                          blue:0.8 alpha:1]]
                             forState:UIControlStateHighlighted];
    [connectButton sizeToFit];
    connectButton.bounds = CGRectMake(connectButton.bounds.origin.x, connectButton.bounds.origin.y, connectButton.bounds.size.width + 12, connectButton.bounds.size.height + 12);
    connectButton.layer.masksToBounds = YES;
    connectButton.layer.cornerRadius = 5;
    return connectButton;
}

@end
