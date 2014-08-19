#import "CBMessageIsEmptyError.h"


static NSString* const CBMessageIsEmptyErrorDomain = @"CBMessageIsEmptyErrorDomain";

@implementation CBMessageIsEmptyError
- (instancetype) initError
{
    self = [super initWithDomain:CBMessageIsEmptyErrorDomain code:0 userInfo:nil];
    if (self)
    {

    }

    return self;
}

@end
