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
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DataFetcher : NSObject

FOUNDATION_EXPORT NSString *const HOST_URL;

+(instancetype) sharedInstance;

// clue for improper use (produces compile time error)
+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (NSMutableArray *) fetchTrains;
- (NSMutableArray *) fetchEquipments;

- (void) setAlarmResolved:(NSString *)alarmId;

- (UIImage *)fetchMap;

@end

#endif
