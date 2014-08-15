#import "CBMessage.h"


@implementation CBMessage

- (instancetype) initWithText:(NSString*) text
                     imageUrl:(NSString*) imageUrl
                   imageWidth:(int) imageWidth
                  imageHeight:(int) imageHeight
                     linkText:(NSString*) linkText
      linkAndroidExecuteParam:(NSString*) linkAndroidExecuteParam
       linkAndroidMarketParam:(NSString*) linkAndroidMarketParam
          linkIosExecuteParam:(NSString*) linkIosExecuteParam
                   buttonText:(NSString*) buttonText
    buttonAndroidExecuteParam:(NSString*) buttonAndroidExecuteParam
     buttonAndroidMarketParam:(NSString*) buttonAndroidMarketParam
        buttonIosExecuteParam:(NSString*) buttonIosExecuteParam
                 notification:(NSString*) notification
{
    self = [super init];
    if (self)
    {
        _text = text;
        _imageUrl = imageUrl;
        _linkText = linkText;
        _linkAndroidExecuteParam = linkAndroidExecuteParam;
        _linkAndroidMarketParam = linkAndroidMarketParam;
        _linkIosExecuteParam = linkIosExecuteParam;
        _buttonText = buttonText;
        _buttonAndroidExecuteParam = buttonAndroidExecuteParam;
        _buttonAndroidMarketParam = buttonAndroidMarketParam;
        _buttonIosExecuteParam = buttonIosExecuteParam;
        _imageWidth = imageWidth;
        _imageHeight = imageHeight;
        _notification = notification;
    }

    return self;
}

+ (instancetype) messageWithText:(NSString*) text
                        imageUrl:(NSString*) imageUrl
                      imageWidth:(int) imageWidth
                     imageHeight:(int) imageHeight
                        linkText:(NSString*) linkText
         linkAndroidExecuteParam:(NSString*) linkAndroidExecuteParam
          linkAndroidMarketParam:(NSString*) linkAndroidMarketParam
             linkIosExecuteParam:(NSString*) linkIosExecuteParam
                      buttonText:(NSString*) buttonText
       buttonAndroidExecuteParam:(NSString*) buttonAndroidExecuteParam
        buttonAndroidMarketParam:(NSString*) buttonAndroidMarketParam
           buttonIosExecuteParam:(NSString*) buttonIosExecuteParam
                    notification:(NSString*) notification
{
    return [[self alloc] initWithText:text
                             imageUrl:imageUrl
                           imageWidth:imageWidth
                          imageHeight:imageHeight
                             linkText:linkText
              linkAndroidExecuteParam:linkAndroidExecuteParam
               linkAndroidMarketParam:linkAndroidMarketParam
                  linkIosExecuteParam:linkIosExecuteParam
                           buttonText:buttonText
            buttonAndroidExecuteParam:buttonAndroidExecuteParam
             buttonAndroidMarketParam:buttonAndroidMarketParam
                buttonIosExecuteParam:buttonIosExecuteParam
                         notification:notification];
}

- (NSString*) description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@" text=%@", self.text];
    [description appendFormat:@", imageUrl=%@", self.imageUrl];
    [description appendFormat:@", imageWidth=%i", self.imageWidth];
    [description appendFormat:@", imageHeight=%i", self.imageHeight];
    [description appendFormat:@", linkText=%@", self.linkText];
    [description appendFormat:@", linkAndroidExecuteParam=%@", self.linkAndroidExecuteParam];
    [description appendFormat:@", linkAndroidMarketParam=%@", self.linkAndroidMarketParam];
    [description appendFormat:@", linkIosExecuteParam=%@", self.linkIosExecuteParam];
    [description appendFormat:@", buttonText=%@", self.buttonText];
    [description appendFormat:@", buttonAndroidExecuteParam=%@", self.buttonAndroidExecuteParam];
    [description appendFormat:@", buttonAndroidMarketParam=%@", self.buttonAndroidMarketParam];
    [description appendFormat:@", buttonIosExecuteParam=%@", self.buttonIosExecuteParam];
    [description appendFormat:@", notification=%@", self.notification];
    [description appendString:@">"];
    return description;
}

+ (BOOL) isBlank:(NSString*) string
{
    return !string || [string length] == 0;
}

- (BOOL) isEmpty
{
    return [CBMessage isBlank:self.notification] ||
      ([CBMessage isBlank:self.linkText]
        && [CBMessage isBlank:self.buttonText]
        && [CBMessage isBlank:self.text]
        && [CBMessage isBlank:self.imageUrl]);
}
@end
