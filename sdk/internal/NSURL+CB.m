#import "NSURL+CB.h"


@implementation NSURL(CB)

- (NSDictionary*) decodeParameters
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    if (self.query != nil && self.query.length > 0)
    {
        for (NSString* param in [self.query componentsSeparatedByString:@"&"])
        {
            NSArray* keyValuePair = [param componentsSeparatedByString:@"="];
            if ([keyValuePair count] < 2) continue;
            [params setObject:[[keyValuePair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[keyValuePair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }

    return params;
}

@end
