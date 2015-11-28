#ifndef ios_GeoStationsIdDataSource_h
#define ios_GeoStationsIdDataSource_h

#import "MLPAutoCompleteTextFieldDataSource.h"
#import <CoreLocation/CoreLocation.h>

@interface GeoStationsIdsDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

@property (nonatomic, weak) NSDictionary *geoStationNameToId;
@property (nonatomic, strong) CLLocation *currentLocation;

- (GeoStationsIdsDataSource *) initWithLocation:(CLLocation *)location;

@end

#endif
