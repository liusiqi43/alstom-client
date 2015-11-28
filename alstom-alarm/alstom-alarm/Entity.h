#import <Foundation/Foundation.h>

@protocol Entity
@required
- (NSString *)getTitle;
- (NSString *)getDesc1;
- (NSString *)getDesc2;
- (NSString *)getDesc3;
- (NSString *)getVisualUrl;
- (NSArray *)getAlarms;
- (NSString *)getType;
@end