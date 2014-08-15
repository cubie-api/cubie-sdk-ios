#import <Foundation/Foundation.h>

@interface UIImage(CB)
+ (UIImage*) imageWithRect:(CGRect) rect color:(UIColor*) color;

+ (UIImage*) stretchableImageWithColor:(UIColor*) color;
@end