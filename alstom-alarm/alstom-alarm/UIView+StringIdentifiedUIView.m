#import "UIView+StringIdentifiedUIView.h"
#import <objc/runtime.h>

@implementation UIView (StringIdentifiedUIView)

static NSString *kStringTagKey = @"StringTagKey";
static NSString *kTimerKey = @"TimerKey";
static NSString *kDefaultColorKey = @"DefaultColor";

- (NSString *)stringTag
{
    return (NSString*) objc_getAssociatedObject(self, CFBridgingRetain(kStringTagKey));
}

- (void)setStringTag:(NSString *)stringTag
{
    objc_setAssociatedObject(self, CFBridgingRetain(kStringTagKey), stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)defaultColor
{
    return (UIColor *) objc_getAssociatedObject(self, CFBridgingRetain(kDefaultColorKey));
}

- (void)setDefaultColor:(UIColor *)color
{
    objc_setAssociatedObject(self, CFBridgingRetain(kDefaultColorKey), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer
{
    return (NSTimer*) objc_getAssociatedObject(self, CFBridgingRetain(kTimerKey));
}

- (void)setTimer:(NSTimer *)timer
{
    objc_setAssociatedObject(self, CFBridgingRetain(kTimerKey), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setColor
{
    if (![self.backgroundColor isEqual:[self defaultColor]]) {
        self.backgroundColor = [self defaultColor];
    } else {
        self.backgroundColor = (UIColor *) [self.timer userInfo];
    }
}

- (void) startBlinkingWithColor:(UIColor *)color
                        default:(UIColor *)defaultColor
{
    self.defaultColor = defaultColor;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(setColor)
                                                userInfo:color
                                                 repeats:YES];
}

-(void) stopBlinking
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
