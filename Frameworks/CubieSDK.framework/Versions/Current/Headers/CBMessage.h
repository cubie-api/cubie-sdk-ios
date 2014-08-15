#import <Foundation/Foundation.h>


@interface CBMessage : NSObject

@property (nonatomic, readonly, copy) NSString* text;
@property (nonatomic, readonly, copy) NSString* imageUrl;
@property (nonatomic, readonly, assign) int imageWidth;
@property (nonatomic, readonly, assign) int imageHeight;
@property (nonatomic, readonly, copy) NSString* linkText;
@property (nonatomic, readonly, copy) NSString* linkAndroidExecuteParam;
@property (nonatomic, readonly, copy) NSString* linkAndroidMarketParam;
@property (nonatomic, readonly, copy) NSString* linkIosExecuteParam;
@property (nonatomic, readonly, copy) NSString* buttonText;
@property (nonatomic, readonly, copy) NSString* buttonAndroidExecuteParam;
@property (nonatomic, readonly, copy) NSString* buttonAndroidMarketParam;
@property (nonatomic, readonly, copy) NSString* buttonIosExecuteParam;
@property (nonatomic, readonly, copy) NSString* notification;


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
                    notification:(NSString*) notification;

- (BOOL) isEmpty;
@end
