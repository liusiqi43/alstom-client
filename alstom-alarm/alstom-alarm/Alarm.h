//
//  Alarm.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIColor.h>
#import <Foundation/Foundation.h>


@interface Alarm : NSObject

@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *mAlarmCode;
@property (nonatomic, strong) NSString *mDescription;
@property (nonatomic, strong) NSString *mLevel;
@property (nonatomic, strong) NSString *mStatus;
@property (nonatomic, strong) NSValue *mShape;
@property (nonatomic, strong) NSString *mEquipmentId;

+ (NSArray *) ALARM_LEVELS;
+ (NSArray *) sortAlarms:(NSArray *)alarms;
- (NSComparisonResult) compare:(Alarm *)other;
- (Alarm *) initWithCode:(NSString *)code
                      Id:(NSString *)ID
                   Level:(NSString *)level
                    desc:(NSString *)desc
                  status:(NSString *)status
                   shape:(NSValue *)shape
               equipment:(NSString *)equipmentId;
- (BOOL) pushResolved;
- (UIColor *) AlarmColor;

@end
