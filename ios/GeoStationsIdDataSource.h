//
//  GeoStationsIdDataSource.h
//  ios
//
//  Created by Siqi Liu on 12/22/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#ifndef ios_GeoStationsIdDataSource_h
#define ios_GeoStationsIdDataSource_h

#import "MLPAutoCompleteTextFieldDataSource.h"
#import <CoreLocation/CoreLocation.h>

@interface GeoStationsIdsDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

@property (nonatomic, weak) NSDictionary *geoStationNameToId;
@property (nonatomic, weak) CLLocation *currentLocation;

- (GeoStationsIdsDataSource *) initWithLocation:(CLLocation *)location;

@end

#endif
