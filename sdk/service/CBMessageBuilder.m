#import "CBMessageBuilder.h"
#import "CBMessage.h"
#import "CBMessageActionParams.h"

static int const IMAGE_WIDTH = 192;
static int const IMAGE_HEIGHT = 192;

@interface CBMessageBuilder()
@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, assign) int imageWidth;
@property (nonatomic, assign) int imageHeight;
@property (nonatomic, copy) NSString* linkText;
@property (nonatomic, copy) NSString* buttonText;
@property (nonatomic, strong) CBMessageActionParams* linkAction;
@property (nonatomic, strong) CBMessageActionParams* buttonAction;
@end

@implementation CBMessageBuilder

- (instancetype) initWithText:(NSString*) text
                     imageUrl:(NSString*) imageUrl
                   imageWidth:(int) imageWidth
                  imageHeight:(int) imageHeight
                     linkText:(NSString*) linkText
                   buttonText:(NSString*) buttonText
                   linkAction:(CBMessageActionParams*) linkAction
                 buttonAction:(CBMessageActionParams*) buttonAction
{
    self = [super init];
    if (self)
    {
        _text = text;
        _imageUrl = imageUrl;
        _imageWidth = imageWidth;
        _imageHeight = imageHeight;
        _linkText = linkText;
        _buttonText = buttonText;
        _linkAction = linkAction;
        _buttonAction = buttonAction;
    }

    return self;
}

+ (instancetype) builder
{
    return [[self alloc] initWithText:nil
                             imageUrl:nil
                           imageWidth:0
                          imageHeight:0
                             linkText:nil
                           buttonText:nil
                           linkAction:nil
                         buttonAction:nil
    ];
}

- (instancetype) appButton:(NSString*) buttonText
{
    self.buttonText = buttonText;
    return self;
}

- (instancetype) appButton:(NSString*) buttonText action:(CBMessageActionParams*) buttonAction
{
    self.buttonAction = buttonAction;
    return [self appButton:buttonText];
}

- (instancetype) appLink:(NSString*) linkText
{
    self.linkText = linkText;
    return self;
}

- (instancetype) appLink:(NSString*) linkText action:(CBMessageActionParams*) linkAction
{
    self.linkAction = linkAction;
    return [self appLink:linkText];
}

- (instancetype) image:(NSString*) imageUrl
{
    self.imageUrl = imageUrl;
    self.imageWidth = IMAGE_WIDTH;
    self.imageHeight = IMAGE_HEIGHT;
    return self;
}

- (instancetype) text:(NSString*) text
{
    self.text = text;
    return self;
}

- (CBMessage*) build
{
    return [CBMessage messageWithText:self.text
                             imageUrl:self.imageUrl
                           imageWidth:self.imageWidth
                          imageHeight:self.imageHeight
                             linkText:self.linkText
              linkAndroidExecuteParam:self.linkAction ? self.linkAction.androidExecuteParam : nil
               linkAndroidMarketParam:self.linkAction ? self.linkAction.androidMarketParam : nil
                  linkIosExecuteParam:self.linkAction ? self.linkAction.iosExecuteParam : nil
                           buttonText:self.buttonText
            buttonAndroidExecuteParam:self.buttonAction ? self.buttonAction.androidExecuteParam : nil
             buttonAndroidMarketParam:self.buttonAction ? self.buttonAction.androidMarketParam : nil
                buttonIosExecuteParam:self.buttonAction ? self.buttonAction.iosExecuteParam : nil];

}


@end
