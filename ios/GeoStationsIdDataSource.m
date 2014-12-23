//
//  GeoStationsIdDataSource.m
//  ios
//
//  Created by Siqi Liu on 12/22/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoStationsIdDataSource.h"
#import "DataFetcher.h"

@implementation GeoStationsIdsDataSource

- (GeoStationsIdsDataSource *) initWithLocation:(CLLocation *)location
{
    self = [self init];
    [self setCurrentLocation:location];
    return self;
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
      possibleCompletionsForString:(NSString *)string
{
    if (!self.geoStationNameToId) {
        DataFetcher *fetcher = [DataFetcher sharedInstance];
        self.geoStationNameToId = [fetcher getNearestStationNameToId:_currentLocation];
    }

    return [_geoStationNameToId allKeys];
}


@end

