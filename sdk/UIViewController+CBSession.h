#import <Foundation/Foundation.h>

@interface UIViewController(CBSession)
- (void) onCBSessionOpen:(SEL) onOpen onCBSessionClose:(SEL) onClose;

- (void) connect:(SEL) onOpen;

- (void) disconnect:(SEL) onClose;
@end
