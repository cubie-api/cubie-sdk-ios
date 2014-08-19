#import "CBSession.h"
#import "CBAccessToken.h"
#import "CBPref.h"
#import "CBService.h"
#import "CBUserAccessToken.h"
#import "Cubie.h"
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLog.h>

#ifdef LOG_LEVEL_DEF
#undef LOG_LEVEL_DEF
#endif
#define LOG_LEVEL_DEF myLibLogLevel
static const int myLibLogLevel = LOG_LEVEL_VERBOSE;

static const long long MIN_REFRESH_INTERVAL = 30LL * 24 * 60 * 60 * 1000; // 30 days

static CBSession* currentSession = nil;

@interface CBSession()<UIAlertViewDelegate>
@property (nonatomic, strong) CBAccessToken* accessToken;
@property (nonatomic, strong) NSObject* lock;
@property (nonatomic, copy) SessionCallback callback;
@end

@implementation CBSession

+ (CBSession*) getSession
{
    return currentSession;
}

- (instancetype) initSession
{
    self = [super init];
    if (self)
    {
        _accessToken = nil;
        _lock = [NSObject new];
        _callback = nil;
    }

    return self;
}

+ (void) init:(SessionCallback) callback
{
    if (!currentSession)
    {
        DDLogVerbose(@"CBSession init");
        currentSession = [[CBSession alloc] initSession];
    }
    [currentSession reopen:callback];
}

- (void) reopen:(SessionCallback) callback
{
    if ([self isOpen])
    {
        return;
    }

    DDLogVerbose(@"CBSession reopen");
    CBAccessToken* loadedAccessToken;
    loadedAccessToken = [CBPref loadAccessToken];
    @synchronized (self.lock)
    {
        self.accessToken = loadedAccessToken;
    }

    [self notifySessionCallback:callback];
    [self refreshIfNecessary];
}

- (void) refreshIfNecessary
{
    if (![self needToRefresh])
    {
        return;
    }

    DDLogVerbose(@"CBSession refresh");
    [CBService extendAccessToken:^(CBUserAccessToken* cubieUserAccessToken, NSError* error) {
        if (error)
        {
            [self close];
            return;
        }
        [self updateAccessToken:[[CBAccessToken alloc] initWithUid:cubieUserAccessToken.uid
                                                      openApiAppId:cubieUserAccessToken.appId
                                                       accessToken:cubieUserAccessToken.accessToken
                                                        expireTime:(long long) ([cubieUserAccessToken.expireDate timeIntervalSince1970] * 1000)]];
    }];
}

- (BOOL) needToRefresh
{
    long long int expireTime = [self.accessToken expireTime];
    long long int currentTime = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
    @synchronized (self.lock)
    {
        return [self isOpen]
          && expireTime - currentTime < MIN_REFRESH_INTERVAL;
    }
}

- (void) open:(SessionCallback) callback
{
    if (![self checkAppKey])
    {
        return;
    }
    if (![self checkUrlScheme])
    {
        return;
    }

    self.callback = callback;
    if ([self isOpen])
    {
        [self notifySessionCallback:callback];
        return;
    }

    NSURL* connectUrl = [Cubie connectUrl];
    DDLogVerbose(@"CBSession open:%@", connectUrl);
    if (![[UIApplication sharedApplication] canOpenURL:connectUrl])
    {
        [self askUserToUpdateOrInstallCubie];
        return;
    }

    [[UIApplication sharedApplication] openURL:connectUrl];
}

- (BOOL) checkAppKey
{
    if (![Cubie appKey])
    {
        [[[UIAlertView alloc] initWithTitle:@"CubieAppKey not defined in Info.plist"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]
                       show];
        return NO;
    }
    return YES;
}

- (BOOL) checkUrlScheme
{
    NSString* openUrl = [NSString stringWithFormat:@"cubie-%@", [Cubie appKey]];
    NSArray* urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if (urlTypes)
    {
        for (NSDictionary* urlType in urlTypes)
        {
            NSArray* urlSchemes = urlType[@"CFBundleURLSchemes"];
            if (urlSchemes)
            {
                for (NSString* urlScheme in urlSchemes)
                {
                    if ([urlScheme isEqualToString:openUrl])
                    {
                        return YES;
                    }
                }
            }
        }
    }
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"url scheme %@ not defined in Info.plist",
                                                                   openUrl]
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
                   show];
    return NO;
}

- (void) close:(SessionCallback) callback
{
    self.callback = callback;
    if (![self isOpen])
    {
        [self notifySessionCallback:callback];
        return;
    }

    NSURL* disconnectUrl = [Cubie disconnectUrl:[self getUid]];
    DDLogVerbose(@"CBSession close:%@", disconnectUrl);
    if (![[UIApplication sharedApplication] canOpenURL:disconnectUrl])
    {
        [self close];
        return;
    }

    [[UIApplication sharedApplication] openURL:disconnectUrl];
}

- (void) close
{
    DDLogVerbose(@"CBSession close");
    @synchronized (self.lock)
    {
        [CBPref clearAccessToken];
        self.accessToken = nil;
    }
}

- (void) finishConnect:(CBAccessToken*) accessToken
{
    DDLogVerbose(@"CBSession finishConnect:%@", accessToken);
    [self updateAccessToken:accessToken];
    [self notifySessionCallback:self.callback];
}

- (void) finishDisconnect
{
    DDLogVerbose(@"CBSession finishDisconnect");
    [self close];
    [self notifySessionCallback:self.callback];
}

- (BOOL) isOpen
{
    @synchronized (self.lock)
    {
        return self.accessToken && [self.accessToken isValid];
    }
}

- (NSString*) getUid
{
    @synchronized (self.lock)
    {
        if (!self.accessToken)
        {
            return nil;
        }
        return [self.accessToken uid];
    }
}

- (NSString*) getOpenApiAppId
{
    @synchronized (self.lock)
    {
        if (!self.accessToken)
        {
            return nil;
        }
        return [self.accessToken openApiAppId];
    }

}

- (long long) getExpireTime
{
    @synchronized (self.lock)
    {
        if (!self.accessToken)
        {
            return 0;
        }
        return [self.accessToken expireTime];
    }

}

- (NSString*) getAccessToken
{
    @synchronized (self.lock)
    {
        if (!self.accessToken)
        {
            return nil;
        }
        return [self.accessToken accessToken];
    }

}

- (void) updateAccessToken:(CBAccessToken*) input
{
    DDLogVerbose(@"CBSession updateAccessToken:%@", input);
    @synchronized (self.lock)
    {
        self.accessToken = input;
        [CBPref storeAccessToken:self.accessToken];
    }
}

- (void) notifySessionCallback:(SessionCallback) callback
{
    if (!callback)
    {
        return;
    }

    callback(self);
}

- (void) askUserToUpdateOrInstallCubie
{
    NSLog(@"askUserToUpdateOrInstallCubie");
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Update install cubie"
                                                        message:@"your verison does not support cubie open api"
                                                       delegate:self
                                              cancelButtonTitle:@"Later"
                                              otherButtonTitles:@"Go to App Store", nil];
    [alertView show];
}

- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cubie.com"]];
}

- (void) testMakeAccessTokenNeedToRefresh
{
    if (![self isOpen])
    {
        return;
    }

    DDLogVerbose(@"CBSession testMakeAccessTokenNeedToRefresh");
    [self updateAccessToken:[[CBAccessToken alloc] initWithUid:[self getUid]
                                                  openApiAppId:[self getOpenApiAppId]
                                                   accessToken:[self getAccessToken]
                                                    expireTime:(long long int) (([[NSDate date] timeIntervalSince1970] + 3600) * 1000)]];
}

- (void) testInvalidAccessToken
{
    if (![self isOpen])
    {
        return;
    }

    DDLogVerbose(@"CBSession testInvalidAccessToken");
    [self updateAccessToken:[[CBAccessToken alloc] initWithUid:[self getUid]
                                                  openApiAppId:[self getOpenApiAppId]
                                                   accessToken:[self getAccessToken]
                                                    expireTime:0]];
}
@end
