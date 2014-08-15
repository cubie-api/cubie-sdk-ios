#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cubie : NSObject

+ (NSURL*) connectUrl;

+ (NSURL*) disconnectUrl:(NSString*) uid;

+ (NSString*) appKey;

+ (NSString*) appUniqueDeviceId;

+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication;

+ (UIButton*) buttonWithCubieStyle;
@end
