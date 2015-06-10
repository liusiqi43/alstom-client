//
//  DataFetcher.m
//  ios
//
//  Created by Siqi Liu on 12/19/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"
#import "DataFetcher.h"
#import "Train.h"
#import "Alarm.h"
#import "Equipment.h"

@implementation DataFetcher

NSString *const HOST_URL = @"http://192.168.0.100:3000/";

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
- (NSMutableArray *) fetchTrains
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@alarms/trains", HOST_URL]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *t in parsedObject) {
        NSMutableArray* alarms = [[NSMutableArray alloc] init];
        for (NSDictionary *item in [t objectForKey:@"Alarms"]) {
            if ([[item objectForKey:@"status"] isEqual:@"RESOLVED"])
                continue;
            Alarm *alarm = [[Alarm alloc] initWithCode:[item objectForKey:@"code"]
                                                    Id:[item objectForKey:@"id"]
                                                 Level:[item objectForKey:@"level"]
                                                  desc:[item objectForKey:@"description"]
                                                parent:[item objectForKey:@"Equipement"]];
            [alarms addObject:alarm];
        }
        
        Train *train = [[Train alloc] initWithDirection:[t objectForKey:@"direction"] Station:[t objectForKey:@"last_station"] Id:[t objectForKey:@"name"] alarms:alarms];
        [result addObject:train];
    }
    
    return result;
}

// Always fetch new copy, no caching strategy.
- (NSMutableArray *) fetchEquipments
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@alarms/equipments", HOST_URL]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
//    NSLog(@"%@", parsedObject);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *e in parsedObject) {
        
        NSMutableArray* alarms = [[NSMutableArray alloc] init];
        for (NSDictionary *item in [e objectForKey:@"Alarms"]) {
            if ([[item objectForKey:@"status"] isEqual:@"RESOLVED"])
                continue;
            Alarm *alarm = [[Alarm alloc] initWithCode:[item objectForKey:@"code"]
                                                    Id:[item objectForKey:@"id"]
                                                 Level:[item objectForKey:@"level"]
                                                  desc:[item objectForKey:@"description"]
                                                parent:[item objectForKey:@"Equipement"]];
            [alarms addObject:alarm];
        }
        Equipment *equipment = [[Equipment alloc] initWithType:[e objectForKey:@"type"]
                                                            Id:[e objectForKey:@"name"]
                                                             X:[((NSNumber *) [e objectForKey:@"x"]) floatValue]
                                                             Y:[((NSNumber *) [e objectForKey:@"y"]) floatValue]
                                                        radius:[((NSNumber *) [e objectForKey:@"radius"]) floatValue]
                                                        alarms:alarms];
        [result addObject:equipment];
    }
    
    return result;
}


- (void) setAlarmResolved:(NSString *)alarmId
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@alarms/%@", HOST_URL, alarmId]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    
    NSString *post = @"{\"status\":\"RESOLVED\"}";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
}

- (UIImage *)fetchMap
{
    return [UIImage imageNamed:@"metro"];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@alarms/map/1", HOST_URL]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSLog(@"%@", parsedObject);
    NSData *imageData = [[NSData alloc] initWithData:[NSData dataFromBase64String:[parsedObject objectForKey:@"image"]]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

@end