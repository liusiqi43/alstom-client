//
//  DataFetcher.m
//  ios
//
//  Created by Siqi Liu on 12/19/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "Train.h"

@implementation DataFetcher

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}


-(instancetype) initUniqueInstance {
    return [super init];
}

- (NSDictionary *) getStationNameToId
{
    if (!self.stationNamesToId) {
        self.stationNamesToId = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1], @"Talleres Tláhuac",
                              [NSNumber numberWithInt:2], @"Tláhuac",
                              [NSNumber numberWithInt:3], @"Tlaltenco",
                              [NSNumber numberWithInt:4], @"Zapotitlán",
                              [NSNumber numberWithInt:5], @"Nopalera",
                              [NSNumber numberWithInt:6], @"Olivos",
                              nil];
    }
    return self.stationNamesToId;
}

- (NSNumber *) getIdForStationName:(NSString *)name
{
    return [[self getStationNameToId] objectForKey:name];
}

- (NSNumber *) getIdForNearestStationName:(NSString *)name
{
    return [[self getNearestStationNameToId:nil] objectForKey:name];
}

- (NSDictionary *) getNearestStationNameToId:(CLLocation *)location
{
    if (!self.geoStationNamesToId) {
        self.geoStationNamesToId = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:1], @"Talleres Tláhuac\t134m",
                                    [NSNumber numberWithInt:2], @"Tláhuac\t254m",
                                    [NSNumber numberWithInt:3], @"Tlaltenco\t1.4km",
                                    [NSNumber numberWithInt:4], @"Zapotitlán\t2km",
                                    [NSNumber numberWithInt:5], @"Nopalera\t2.74km",
                                    [NSNumber numberWithInt:6], @"Olivos\t2.88km",
                                    nil];
    }
    return self.geoStationNamesToId;
}

// Always fetch new copy, no caching strategy.
- (NSArray *) fetchTrainsForDeparture:(NSString *)_departureName
                              Arrival:(NSString *)_arrivalName
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (int i = 0; i<4+arc4random_uniform(3); ++i) {
        [res addObject:[[Train alloc] initWithRandom]];
    }
    return res;
}

@end