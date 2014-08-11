#import "CBFriendList.h"
#import "CBFriend.h"


@implementation CBFriendList

- (id) init
{
    self = [super init];
    if (self)
    {
        _allFriends = [NSMutableArray array];
        _hasMore = YES;
    }

    return self;
}

+ (instancetype) list
{
    return [[self alloc] init];
}

- (void) update:(NSArray*) friends
{
    NSMutableArray* newFriends = [NSMutableArray array];
    for (NSDictionary* rawFriend in friends)
    {
        CBFriend* friend = [CBFriend decode:rawFriend];
        if ([self.allFriends containsObject:friend])
        {
            continue;
        }
        [newFriends addObject:friend];
        [self.allFriends addObject:friend];
    }
    _hasMore = [newFriends count] > 0;
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.allFriends=%@", self.allFriends];
    [description appendFormat:@", self.hasMore=%d", self.hasMore];
    [description appendString:@">"];
    return description;
}


@end
