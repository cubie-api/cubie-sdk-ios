#import "CBService.h"
#import "CBUser.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLRequestSerialization.h"
#import "CBUserAccessToken.h"
#import "CBFriendList.h"
#import "CBFriend.h"
#import "CBMessage.h"
#import "CBMssageRequest.h"
#import "CBSession.h"
#import "CBTransactionRequest.h"
#import "CBServiceError.h"
#import "CBMessageIsEmptyError.h"
#import <CocoaLumberjack/DDLog.h>

#ifdef LOG_LEVEL_DEF
#undef LOG_LEVEL_DEF
#endif
#define LOG_LEVEL_DEF myLibLogLevel
static const int myLibLogLevel = LOG_LEVEL_VERBOSE;

#ifdef DEBUG
static NSString* const EndPoint = @"https://api.cubie.com";
#else
static NSString* const EndPoint = @"https://api.cubie.com";
#endif
static NSString* const AccessTokenHeaderKey = @"X-CUBIE-ACCESS-TOKEN";

const int CBDefaultFriendListPageSize = 100;

NSTimeInterval CBRequestTimeoutInterval = 10;

@implementation CBService

+ (void) extendAccessToken:(void (^)(CBUserAccessToken* cubieUserAccessToken, NSError* error)) done
{
    DDLogVerbose(@"CBService extendAccessToken");
    NSString* url = [NSString stringWithFormat:@"%@%@", EndPoint, @"/v1/api/user/extend-access-token"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:CBRequestTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    [request addValue:[[CBSession getSession] getAccessToken] forHTTPHeaderField:AccessTokenHeaderKey];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        done([CBUserAccessToken decode:responseObject], nil);
    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                done(nil, error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}


+ (void) requestProfile:(void (^)(CBUser* cubieUser, NSError* error)) done
{
    NSString* url = [NSString stringWithFormat:@"%@%@", EndPoint, @"/v1/api/user/me"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:CBRequestTimeoutInterval];
    [request addValue:[[CBSession getSession] getAccessToken] forHTTPHeaderField:AccessTokenHeaderKey];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        done([CBUser decode:responseObject], nil);
    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                done(nil, error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

+ (void) requestFriends:(CBFriendList*) currentFriendList pageSize:(int) pageSize done:(void (^)(CBFriendList* updatedFriendList, NSError* error)) done
{
    DDLogVerbose(@"CBService requestFriends:%@", currentFriendList);
    NSDictionary* params = nil;
    if ([currentFriendList.allFriends count] > 0)
    {
        CBFriend* friend = [currentFriendList.allFriends lastObject];
        params = @{
          @"size" : [NSString stringWithFormat:@"%d", pageSize],
          @"start-friend-uid" : friend.uid
        };
    } else
    {
        params = @{
          @"size" : [NSString stringWithFormat:@"%d", pageSize],
        };
    }

    NSString* url = [NSString stringWithFormat:@"%@%@", EndPoint, @"/v1/api/friend/list"];
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer]
                                                             requestWithMethod:@"GET"
                                                                     URLString:url
                                                                    parameters:params
                                                                         error:nil];
    [request setTimeoutInterval:CBRequestTimeoutInterval];
    [request addValue:[[CBSession getSession] getAccessToken] forHTTPHeaderField:AccessTokenHeaderKey];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak CBFriendList* preventCircularRef = currentFriendList;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        DDLogVerbose(@"CBService requestFriends success:");
        [preventCircularRef update:responseObject];
        done(preventCircularRef, nil);
    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                if (operation.responseObject)
                                                {
                                                    done(nil, [CBServiceError decode:operation.responseObject]);
                                                    return;
                                                }
                                                done(nil, error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

+ (void) sendMessage:(CBMessage*) cubieMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done
{
    if ([cubieMessage isEmpty])
    {
        done([[CBMessageIsEmptyError alloc] initError]);
        return;
    }

    CBMssageRequest* cubieMessageRequest = [CBMssageRequest requestWithReceiverUid:receiverUid
                                                                      cubieMessage:cubieMessage];

    NSString* url = [NSString stringWithFormat:@"%@%@", EndPoint, @"/v1/api/chat/app-message"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:CBRequestTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    DDLogVerbose(@"CBService sendMessage:%@", [cubieMessageRequest toJson]);
    [request setHTTPBody:[[cubieMessageRequest toJson] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[[CBSession getSession] getAccessToken] forHTTPHeaderField:AccessTokenHeaderKey];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        done(nil);
    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                done(error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

+ (void) createTransactionWithPurchaseId:(NSString*) purchaseId
                                itemName:(NSString*) itemName
                                currency:(NSString*) currency
                                   price:(NSDecimalNumber*) price
                            purchaseDate:(NSDate*) purchaseDate
                                   extra:(NSDictionary*) extra
                                    done:(void (^)(NSError* error)) done
{
    CBTransactionRequest* cubieTransactionRequest = [CBTransactionRequest create:purchaseId
                                                                        itemName:itemName
                                                                        currency:currency
                                                                           price:price
                                                                    purchaseDate:purchaseDate
                                                                           extra:extra];

    NSString* url = [NSString stringWithFormat:@"%@%@", EndPoint, @"/v1/api/transaction/create"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:CBRequestTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    DDLogVerbose(@"CBService createTransaction:%@", [cubieTransactionRequest toJson]);
    [request setHTTPBody:[[cubieTransactionRequest toJson] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[[CBSession getSession] getAccessToken] forHTTPHeaderField:AccessTokenHeaderKey];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        done(nil);
    }
                                            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                                done(error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}


@end
