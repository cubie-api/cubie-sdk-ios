#import <Foundation/Foundation.h>


@interface CBMessageActionParams : NSObject
@property (nonatomic, copy) NSString* androidExecuteParam;
@property (nonatomic, copy) NSString* androidMarketParam;
@property (nonatomic, copy) NSString* iosExecuteParam;

+ (instancetype) params;

- (instancetype) androidExecuteParam:(NSString*) androidExecuteParam;

- (instancetype) androidMarketParam:(NSString*) androidMarketParam;

- (instancetype) iosExecuteParam:(NSString*) iosExecuteParam;

- (instancetype) executeParam:(NSString*) androidExecuteParam;

- (instancetype) marketParam:(NSString*) androidMarketParam;

@end
