//
//  StationsNameIdDataSource.h
//  ios
//
//  Created by Siqi Liu on 12/19/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#ifndef ios_StationsNameIdDataSource_h
#define ios_StationsNameIdDataSource_h

#import "MLPAutoCompleteTextFieldDataSource.h"
#import <CoreLocation/CoreLocation.h>

@interface StationsNameIdDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

@property (nonatomic, weak) NSDictionary *stationNameToId;

@end


#endif
