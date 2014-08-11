#import "CBServiceError.h"


static NSString* const CBServiceErrorDomain = @"CBServiceErrorDomain";

@implementation CBServiceError

- (instancetype) initWithReason:(NSString*) reason code:(NSInteger) code
{
    self = [super initWithDomain:CBServiceErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : reason}];
    if (self)
    {
    }

    return self;
}

+ (instancetype) decode:(NSDictionary*) raw
{
    return [[self alloc] initWithReason:raw[@"reason"] code:[raw[@"code"] integerValue]];
}

@end

