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

NSString *const HOST_URL = @"http://169.254.91.226:3000/";

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
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", HOST_URL, @"stations/"]]];
        NSLog(@"Request %@", req.URL);
        NSURLResponse *res = nil;
        NSError *err = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        NSError *localError = nil;
        NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        
        
        NSMutableArray *stationNames = [[NSMutableArray alloc] init];
        NSMutableArray *stationIds = [[NSMutableArray alloc] init];
        for (NSDictionary *item in parsedObject) {
            [stationNames addObject:[item objectForKey:@"name"]];
            [stationIds addObject:[item objectForKey:@"id"]];
        }
        self.stationNamesToId = [[OrderedDictionary alloc] initWithObjects:stationIds forKeys:stationNames];
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

- (NSString *) distanceFormat:(NSString *)distance {
    float dist = [distance floatValue];
    if (dist > 1000) {
        dist /= 1000;
        return [NSString stringWithFormat:@"%.1fkm", dist];
    } else {
        return [NSString stringWithFormat:@"%.1fm", dist];
    }
}

- (NSDictionary *) getNearestStationNameToId:(CLLocation *)location
{
    if (!self.geoStationNamesToId) {
        NSURLRequest *req = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:
                              [NSString stringWithFormat:@"%@stations/@%.2f,%.2f/",
                               HOST_URL,
                               location.coordinate.latitude,
                               location.coordinate.longitude]]];
        NSLog(@"%@", req.URL);
        NSURLResponse *res = nil;
        NSError *err = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        NSError *localError = nil;
        NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSMutableArray *stationNames = [[NSMutableArray alloc] init];
        NSMutableArray *stationIds = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in parsedObject[0]) {
            NSString *entry = [NSString stringWithFormat:@"%@\t%@",
                               [item objectForKey:@"name"],
                               [self distanceFormat:[item objectForKey:@"distance"]]];
            [stationNames addObject:entry];
            [stationIds addObject:[item objectForKey:@"id"]];
        }
        self.geoStationNamesToId = [[OrderedDictionary alloc] initWithObjects:stationIds forKeys:stationNames];
    }
    NSLog(@"%@", self.geoStationNamesToId);
    return self.geoStationNamesToId;
}

// Always fetch new copy, no caching strategy.
- (NSArray *) fetchTrainsForDeparture:(NSNumber *)_departureId
                              Arrival:(NSNumber *)_arrivalId
{
    NSLog(@"%@ --> %@", _departureId, _arrivalId);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@trains/%d/%d/", HOST_URL, [_departureId intValue], [_arrivalId intValue]]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSLog(@"%@", parsedObject);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *item in parsedObject) {
        NSArray* wagons = [item objectForKey:@"wagons"];
        NSMutableArray* densities = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in wagons) {
            [densities addObject:[item objectForKey:@"density"]];
        }
        
        Train *train = [[Train alloc] initWithWaitTime:[item objectForKey:@"duration"]
                                               Density:[item objectForKey:@"density"]
                                                wagons:densities];
        [result addObject:train];
    }
    
    return [result sortedArrayUsingSelector:@selector(compareArrivalTime:)];
}

@end