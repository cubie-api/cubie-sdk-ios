#import "CBMssageRequest.h"
#import "CBMessage.h"
#import "JSONKit.h"


@implementation CBMssageRequest

- (instancetype) initWithReceiverUid:(NSString*) receiverUid cubieMessage:(CBMessage*) cubieMessage
{
    self = [super init];
    if (self)
    {
        _receiverUid = receiverUid;
        _cubieMessage = cubieMessage;
    }

    return self;
}

+ (instancetype) requestWithReceiverUid:(NSString*) receiverUid cubieMessage:(CBMessage*) cubieMessage
{
    return [[self alloc] initWithReceiverUid:receiverUid cubieMessage:cubieMessage];
}

+ (id) trimToNull:(NSString*) value
{
    if (!value || value.length == 0)
    {
        return [NSNull null];
    }
    return value;
}

- (NSString*) toJson
{
    NSDictionary* dictionary = @{
      @"receiver_uid" : self.receiverUid,
      @"text" : [CBMssageRequest trimToNull:self.cubieMessage.text],
      @"image_url" : [CBMssageRequest trimToNull:self.cubieMessage.imageUrl],
      @"image_width" : [NSString stringWithFormat:@"%d", self.cubieMessage.imageWidth],
      @"image_height" : [NSString stringWithFormat:@"%d", self.cubieMessage.imageHeight],
      @"link_text" : [CBMssageRequest trimToNull:self.cubieMessage.linkText],
      @"link_android_execute_param" : [CBMssageRequest trimToNull:self.cubieMessage.linkAndroidExecuteParam],
      @"link_android_market_param" : [CBMssageRequest trimToNull:self.cubieMessage.linkAndroidMarketParam],
      @"link_ios_execute_param" : [CBMssageRequest trimToNull:self.cubieMessage.linkIosExecuteParam],
      @"button_text" : [CBMssageRequest trimToNull:self.cubieMessage.buttonText],
      @"button_android_execute_param" : [CBMssageRequest trimToNull:self.cubieMessage.buttonAndroidExecuteParam],
      @"button_android_market_param" : [CBMssageRequest trimToNull:self.cubieMessage.buttonAndroidMarketParam],
      @"button_ios_execute_param" : [CBMssageRequest trimToNull:self.cubieMessage.buttonIosExecuteParam],
      @"notification" : [CBMssageRequest trimToNull:self.cubieMessage.notification]
    };
    return [dictionary JSONString];
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"receiverUid=%@", self.receiverUid];
    [description appendFormat:@", cubieMessage=%@", self.cubieMessage];
    [description appendString:@">"];
    return description;
}


@end
