#import "CBPref.h"
#import "CBAccessToken.h"

static NSString* const AccessTokenKey = @"CBAccessToken";

@implementation CBPref

+ (void) storeAccessToken:(CBAccessToken*) accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:accessToken]
                                              forKey:AccessTokenKey];
}

+ (CBAccessToken*) loadAccessToken
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenKey];
    if (!data)
    {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void) clearAccessToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AccessTokenKey];
}

+ (id) load:(NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+ (void) store:(NSString*) key value:(id) value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}


@end
