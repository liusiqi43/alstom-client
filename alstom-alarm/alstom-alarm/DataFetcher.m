#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "Train.h"
#import "Alarm.h"
#import "Entity.h"
#import "Equipment.h"

@implementation DataFetcher

NSString *const HOST_URL = @"http://127.0.0.1:3000";

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
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/alarms/trains", HOST_URL]]];
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
                                                status:[item objectForKey:@"status"]
                                                 shape:[NSValue valueWithCGRect:CGRectMake([[item objectForKey:@"x1"] floatValue],
                                                                                           [[item objectForKey:@"y1"] floatValue],
                                                                                           [[item objectForKey:@"x4"] floatValue] - [[item objectForKey:@"x1"] floatValue],
                                                                                           [[item objectForKey:@"y4"] floatValue]- [[item objectForKey:@"y1"] floatValue])]
                                             equipment:[[item objectForKey:@"Equipment"] objectForKey:@"name"]];
            [alarms addObject:alarm];
        }
        
        Train *train = [[Train alloc] initWithDirection:[t objectForKey:@"direction"]
                                                Station:[t objectForKey:@"last_station"]
                                                     Id:[t objectForKey:@"name"]
                                                 Status:[t objectForKey:@"status"]
                                                 alarms:alarms];
        [result addObject:train];
    }
    
    return result;
}

// Always fetch new copy, no caching strategy.
- (NSMutableArray *) fetchEquipments
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/alarms/equipments", HOST_URL]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *e in parsedObject) {
        NSLog(@"Parsed dictionary %@", e);
        NSDictionary* stationDetails = [e objectForKey:@"Station"];
        NSDictionary* coordinates = [e objectForKey:@"ImagePosition"];
        
        // submapping is nil if there is only one level of alarms.
        NSDictionary *submapping = [self parseSubMapping:stationDetails];
        
        NSMutableArray* alarms = nil;
        Equipment *equipment = nil;
        if (submapping == nil) {
            NSLog(@"Interlockings");
            // Interlockings.
            alarms = [[NSMutableArray alloc] init];
            for (NSDictionary *item in [e objectForKey:@"Alarms"]) {
                if ([[item objectForKey:@"status"] isEqual:@"RESOLVED"])
                    continue;
                
                Alarm *alarm = [[Alarm alloc] initWithCode:[item objectForKey:@"code"]
                                                        Id:[item objectForKey:@"id"]
                                                     Level:[item objectForKey:@"level"]
                                                      desc:[item objectForKey:@"description"]
                                                    status:[item objectForKey:@"status"]
                                                     shape:nil
                                                equipment:[e objectForKey:@"id"]];
                [alarms addObject:alarm];
            }
            equipment = [[Equipment alloc] initWithType:[e objectForKey:@"type"]
                                                     Name:[e objectForKey:@"name"]
                                                     Id:[e objectForKey:@"id"]
                                                  Shape:[self getShapeFromDict:coordinates]
                                                 Visual:@"/media/interlocking.jpg"
                                                 Alarms:alarms];
        } else {
            NSLog(@"Stations");
            // Two level: stations.
            alarms = [self getAlarmsFromDict:stationDetails
                                 WithMapping:submapping];
            equipment = [[Equipment alloc] initWithType:[e objectForKey:@"type"]
                                                   Name:[e objectForKey:@"name"]
                                                     Id:[e objectForKey:@"id"]
                                                  Shape:[self getShapeFromDict:coordinates]
                                                 Visual:[[stationDetails objectForKey:@"map"] objectForKey:@"image"]
                                                 Alarms:alarms];
        }
        [result addObject:equipment];
    }
    return result;
}

- (NSMutableArray*)getAlarmsFromDict:(NSDictionary *)stationDetails
                         WithMapping:(NSDictionary *)submapping
{
    NSMutableArray * output = [[NSMutableArray alloc] init];
    for (NSDictionary *a in [stationDetails objectForKey:@"allAlarms"]) {
        if ([[a objectForKey:@"status"] isEqual:@"RESOLVED"])
            continue;
        Alarm *alarm = [[Alarm alloc] initWithCode:[a objectForKey:@"code"]
                                                Id:[a objectForKey:@"id"]
                                             Level:[a objectForKey:@"level"]
                                              desc:[a objectForKey:@"description"]
                                            status:[a objectForKey:@"status"]
                                             shape:[submapping objectForKey:[[a objectForKey:@"Equipment"] objectForKey:@"id"]]
                                         equipment:[[a objectForKey:@"Equipment"] objectForKey:@"id"]];
        [output addObject:alarm];
    }
    return output;
}

- (NSDictionary *) parseSubMapping:(NSDictionary *)dict
{
    if (dict == nil || [dict isEqual:[NSNull null]]) return nil;
    NSLog(@"%@", dict);
    NSMutableDictionary * output = nil;
    NSDictionary *map = [dict objectForKey:@"map"];
    if (map) {
        output = [[NSMutableDictionary alloc] init];
        [output setObject:[map objectForKey:@"image"] forKey:@"visual"];
        
        for (NSDictionary *subequipment in [map objectForKey:@"ImagePositions"]) {
            [output setObject:[self getShapeFromDict:subequipment]
                       forKey:[[subequipment objectForKey:@"Equipment"] objectForKey:@"id"]];
        }
    }
    return output;
}

- (NSValue *) getShapeFromDict:(NSDictionary *) dict
{
    if (dict == nil) return nil;
    return [NSValue valueWithCGRect:CGRectMake([[dict objectForKey:@"x1"] floatValue],
                                               [[dict objectForKey:@"y1"] floatValue],
                                               [[dict objectForKey:@"x4"] floatValue] - [[dict objectForKey:@"x1"] floatValue],
                                               [[dict objectForKey:@"y4"] floatValue] - [[dict objectForKey:@"y1"] floatValue])];
}


- (BOOL) setAlarmResolved:(NSString *)alarmId
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/alarms/%@", HOST_URL, alarmId]]];
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
    
    return err == nil;
}

- (UIImage *)getMainMap
{
    return [self getMediaWithUrl:@"/media/main.png"];
}

- (UIImage *)getMediaWithUrl:(NSString*) url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_URL, url]]];
    NSLog(@"%@", req.URL);
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    NSData *imageData = [[NSData alloc] initWithData:data];
    
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

@end