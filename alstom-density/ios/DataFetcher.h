//
//  DataFetcher.h
//  ios
//
//  Created by Siqi Liu on 12/19/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#ifndef ios_DataFetcher_h
#define ios_DataFetcher_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OrderedDictionary.h"

@interface DataFetcher : NSObject

@property (nonatomic, strong) OrderedDictionary *stationNamesToId;
@property (nonatomic, strong) OrderedDictionary *geoStationNamesToId;

FOUNDATION_EXPORT NSString *const HOST_URL;

+(instancetype) sharedInstance;

// clue for improper use (produces compile time error)
+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));


- (NSDictionary *) getStationNameToId;
- (NSDictionary *) getNearestStationNameToId:(CLLocation *)location;
- (NSNumber *) getIdForStationName:(NSString *)name;
- (NSNumber *) getIdForNearestStationName:(NSString *)name;
- (NSArray *) fetchTrainsForDeparture:(NSNumber *)_departureId
                              Arrival:(NSNumber *)_arrivalId;

@end

#endif
