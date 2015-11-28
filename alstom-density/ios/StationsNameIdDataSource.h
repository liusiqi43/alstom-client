#ifndef ios_StationsNameIdDataSource_h
#define ios_StationsNameIdDataSource_h

#import "MLPAutoCompleteTextFieldDataSource.h"
#import <CoreLocation/CoreLocation.h>

@interface StationsNameIdDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

@property (nonatomic, weak) NSDictionary *stationNameToId;

@end


#endif
