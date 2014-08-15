#import <Foundation/Foundation.h>

@class CBMessage;


@interface CBMssageRequest : NSObject

@property (nonatomic, readonly, copy) NSString* receiverUid;
@property (nonatomic, readonly, strong) CBMessage* cubieMessage;

- (NSString*) toJson;

+ (instancetype) requestWithReceiverUid:(NSString*) receiverUid cubieMessage:(CBMessage*) cubieMessage;

@end
