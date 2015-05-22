//
//  UIView+StringIdentifiedUIView.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/22/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "UIView+StringIdentifiedUIView.h"
#import <objc/runtime.h>

@implementation UIView (StringIdentifiedUIView)

static NSString *kStringTagKey = @"StringTagKey";
static NSString *kTimerKey = @"TimerKey";

- (NSString *)stringTag
{
    return (NSString*) objc_getAssociatedObject(self, CFBridgingRetain(kStringTagKey));
}

- (void)setStringTag:(NSString *)stringTag
{
    objc_setAssociatedObject(self, CFBridgingRetain(kStringTagKey), stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    if (![self.backgroundColor isEqual:[UIColor blueColor]]) {
        self.backgroundColor = [UIColor blueColor];
    } else {
        self.backgroundColor = (UIColor *) [self.timer userInfo];
    }
}

- (void) startBlinkingWithColor:(UIColor *)color
{
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
