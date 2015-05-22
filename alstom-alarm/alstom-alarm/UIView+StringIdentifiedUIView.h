//
//  UIView+StringIdentifiedUIView.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/22/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StringIdentifiedUIView)
@property (nonatomic, strong) NSString *stringTag;
@property (nonatomic, strong) NSTimer *timer;

- (void) startBlinkingWithColor:(UIColor *)color;
- (void) stopBlinking;
- (void) setColor;

@end
