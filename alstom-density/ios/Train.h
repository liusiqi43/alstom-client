#import <Foundation/Foundation.h>

@interface Train : NSObject

// Arrival time given in minutes
@property (nonatomic, strong) NSNumber *waitTime;
// Average density of the train
@property (nonatomic, strong) NSNumber *avgDensity;
// An array of densities of wagon
@property (nonatomic, strong) NSArray *wagonDensities;

- (Train *) initWithRandom;

- (Train *) initWithWaitTime:(NSNumber *)waitTime
                     Density:(NSNumber *)avgDensity
                      wagons:(NSArray *)wagons;

- (NSComparisonResult)compareArrivalTime:(Train *)other;

@end
