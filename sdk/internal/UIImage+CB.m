#import <UIKit/UIKit.h>
#import "UIImage+CB.h"


@implementation UIImage(CB)

+ (UIImage *) imageWithRect:(CGRect) rect color:(UIColor *) color {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *) stretchableImageWithColor:(UIColor *) color {
    return [[UIImage imageWithRect:CGRectMake(0, 0, 10, 10)
                             color:color]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 4, 4)];
}
@end
