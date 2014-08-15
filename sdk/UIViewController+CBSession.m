#import <UIKit/UIKit.h>
#import "CBSession.h"
#import <CocoaLumberjack/DDLog.h>

#ifdef LOG_LEVEL_DEF
#undef LOG_LEVEL_DEF
#endif
#define LOG_LEVEL_DEF myLibLogLevel
static const int myLibLogLevel = LOG_LEVEL_VERBOSE;


@implementation UIViewController(CBSession)

- (void) onCBSessionOpen:(SEL) onOpen onCBSessionClose:(SEL) onClose
{
    if ([CBSession getSession] && [[CBSession getSession] isOpen])
    {
        DDLogVerbose(@"UIViewController+CBSession isOpen");
        if (onOpen)
        {
            [self performSelector:onOpen withObject:nil afterDelay:0];
        }
    } else
    {
        DDLogVerbose(@"UIViewController+CBSession init");
        __weak UIViewController* preventCircularRef = self;
        [CBSession init:^(CBSession* session) {
            DDLogVerbose(@"UIViewController+CBSession init:%d", [session isOpen]);
            if ([session isOpen])
            {
                if (onOpen)
                {
                    [preventCircularRef performSelector:onOpen withObject:nil afterDelay:0];
                }
            } else
            {
                if (onClose)
                {
                    [preventCircularRef performSelector:onClose withObject:nil afterDelay:0];
                }
            }
        }];
    }
}

- (void) connect:(SEL) onOpen
{
    DDLogVerbose(@"UIViewController+CBSession openCBSession");
    __weak UIViewController* preventCircularRef = self;
    [[CBSession getSession] open:^(CBSession* session) {
        if ([session isOpen])
        {
            DDLogVerbose(@"UIViewController+CBSession connect:%d", [session isOpen]);
            if (onOpen)
            {
                [preventCircularRef performSelector:onOpen withObject:nil afterDelay:0];
            }
        }
    }];
}

- (void) disconnect:(SEL) onClose
{
    DDLogVerbose(@"UIViewController+CBSession closeCBSession");
    __weak UIViewController* preventCircularRef = self;
    [[CBSession getSession] close:^(CBSession* session) {
        DDLogVerbose(@"UIViewController+CBSession disconnect:%d", [session isOpen]);
        if (![session isOpen])
        {
            if (onClose)
            {
                [preventCircularRef performSelector:onClose withObject:nil afterDelay:0];
            }
        }
    }];
}

@end