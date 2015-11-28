#import <UIKit/UIKit.h>

@interface UIView (StringIdentifiedUIView)
@property (nonatomic, strong) NSString *stringTag;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIColor *defaultColor;

- (void) startBlinkingWithColor:(UIColor *)color
                        default:(UIColor *)defaultColor;
- (void) stopBlinking;
- (void) setColor;

@end
