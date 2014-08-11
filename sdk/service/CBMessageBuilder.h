#import <Foundation/Foundation.h>

@class CBMessage;
@class CBMessageActionParams;


@interface CBMessageBuilder : NSObject

+ (instancetype) builder;

- (instancetype) appButton:(NSString*) buttonText;

- (instancetype) appButton:(NSString*) buttonText action:(CBMessageActionParams*) buttonAction;

- (instancetype) appLink:(NSString*) linkText;

- (instancetype) appLink:(NSString*) linkText action:(CBMessageActionParams*) linkAction;

- (instancetype) image:(NSString*) imageUrl;

- (instancetype) text:(NSString*) text;

- (CBMessage*) build;

@end
