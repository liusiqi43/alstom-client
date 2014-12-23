//
//  Train.m
//  ios
//
//  Created by Siqi Liu on 12/23/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Train.h"

@implementation Train

- (Train *) initWithRandom
{
    self = [self init];
    
    self.avgDensity = [NSNumber numberWithDouble:arc4random_uniform(100)/100];
    self.arrivalTime = [NSNumber numberWithInt:arc4random_uniform(10)];
    for (int i=0; i<4+arc4random_uniform(4); ++i) {
        [self.wagonDensities addObject:[NSNumber numberWithDouble:arc4random_uniform(100)/100]];
    }
    
    return self;
}

@end
