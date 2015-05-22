//
//  CenteredScrollView.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/22/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "CenteredScrollView.h"

@implementation CenteredScrollView

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView* v = [self.delegate viewForZoomingInScrollView:self];
    CGFloat svw = self.bounds.size.width;
    CGFloat svh = self.bounds.size.height;
    CGFloat vw = v.frame.size.width;
    CGFloat vh = v.frame.size.height;
    CGRect f = v.frame;
    if (vw < svw)
        f.origin.x = (svw - vw) / 2.0;
    else
        f.origin.x = 0;
    if (vh < svh)
        f.origin.y = (svh - vh) / 2.0;
    else
        f.origin.y = 0;
    v.frame = f;
}

@end
