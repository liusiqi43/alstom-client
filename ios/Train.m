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
    self.wagonDensities = [[NSMutableArray alloc] init];
    self.arrivalTime = [NSNumber numberWithInt:arc4random_uniform(10)];
    double sum = 0;
    for (int i=0; i<3+arc4random_uniform(8); ++i) {
        double n = arc4random_uniform(100)/100.0f;
        sum += n;
        [self.wagonDensities addObject:[NSNumber numberWithFloat:n]];
    }
    self.avgDensity = [NSNumber numberWithFloat:sum/[self.wagonDensities count]];
    return self;
}

@end
