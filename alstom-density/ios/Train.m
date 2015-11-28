#import <Foundation/Foundation.h>
#import "Train.h"

@implementation Train

- (Train *) initWithRandom
{
    self = [self init];
    self.wagonDensities = [[NSArray alloc] init];
    self.waitTime = [NSNumber numberWithInt:arc4random_uniform(10)];
    double sum = 0;
    for (int i=0; i<3+arc4random_uniform(8); ++i) {
        double n = (40+arc4random_uniform(60))/100.0f;
        sum += n;
    }
    self.avgDensity = [NSNumber numberWithFloat:sum/[self.wagonDensities count]];
    return self;
}

- (Train *) initWithWaitTime:(NSNumber *)waitTime
                     Density:(NSNumber *)avgDensity
                      wagons:(NSArray *)wagons {
    self = [self init];
    self.wagonDensities = wagons;
    self.waitTime = [NSNumber numberWithInt:[waitTime intValue] / 60];
    self.avgDensity = avgDensity;
    NSLog(@"Wagons Densites: %@", wagons);
    return self;
}

- (NSComparisonResult)compareArrivalTime:(Train *)other {
    return [self.waitTime compare:other.waitTime];
}

@end
