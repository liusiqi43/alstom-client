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
        
        Train *train = [[Train alloc] initWithRandom];
        [result addObject:train];
    }
    
    return result;
}


// Always fetch new copy, no caching strategy.
- (NSArray *) fetchAllTrains
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@trains/", HOST_URL]]];
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
        
        Train *train = [[Train alloc] initWithRandom];
        [result addObject:train];
    }
    
    return result;
}

- (void) setAlarmResolved:(NSString *)alarmId
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@alarms/delete/%@", HOST_URL, alarmId]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
}

@end