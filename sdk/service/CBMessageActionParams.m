#import "CBMessageActionParams.h"


@implementation CBMessageActionParams
- (instancetype) initWithAndroidExecuteParam:(NSString*) androidExecuteParam androidMarketParam:(NSString*) androidMarketParam iosExecuteParam:(NSString*) iosExecuteParam
{
    self = [super init];
    if (self)
    {
        _androidExecuteParam = androidExecuteParam;
        _androidMarketParam = androidMarketParam;
        _iosExecuteParam = iosExecuteParam;
    }

    return self;
}

+ (instancetype) params
{
    return [[self alloc] initWithAndroidExecuteParam:nil
                                  androidMarketParam:nil
                                     iosExecuteParam:nil];
}

- (instancetype) androidExecuteParam:(NSString*) androidExecuteParam
{
    self.androidExecuteParam = androidExecuteParam;
    return self;
}

- (instancetype) androidMarketParam:(NSString*) androidMarketParam
{
    self.androidMarketParam = androidMarketParam;
    return self;
}

- (instancetype) iosExecuteParam:(NSString*) iosExecuteParam
{
    self.iosExecuteParam = iosExecuteParam;
    return self;
}

- (instancetype) executeParam:(NSString*) executeParam
{
    self.androidExecuteParam = executeParam;
    self.iosExecuteParam = executeParam;
    return self;
}

- (instancetype) marketParam:(NSString*) marketParam
{
    self.androidMarketParam = marketParam;
    return self;
}


@end
