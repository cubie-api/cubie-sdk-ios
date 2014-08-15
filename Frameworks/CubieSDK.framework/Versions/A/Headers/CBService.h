#import <Foundation/Foundation.h>

extern const int CBDefaultFriendListPageSize;
extern NSTimeInterval CBRequestTimeoutInterval;

@class CBUser;
@class CBUserAccessToken;
@class CBFriend;
@class CBFriendList;
@class CBMessage;
@class CBSession;
@class CBTransactionRequest;

@interface CBService : NSObject

+ (void) extendAccessToken:(void (^)(CBUserAccessToken* cubieUserAccessToken, NSError* error)) done;

+ (void) requestMe:(void (^)(CBUser* cubieUser, NSError* error)) done;

+ (void) requestFriends:(CBFriendList*) currentFriendListOrNil pageSize:(int) pageSize done:(void (^)(CBFriendList* updatedFriendList, NSError* error)) done;

+ (void) sendMessage:(CBMessage*) cubieMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done;

+ (void) createTransaction:(NSString*) purchaseId
                  itemName:(NSString*) itemName
                  currency:(NSString*) currency
                     price:(NSDecimalNumber*) price
              purchaseDate:(NSDate*) purchaseDate
                     extra:(NSDictionary*) extra
                      done:(void (^)(NSError* error)) done;

@end
