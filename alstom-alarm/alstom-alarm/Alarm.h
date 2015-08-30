//
//  Alarm.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *mParentId;
@property (nonatomic, strong) NSString *mAlarmCode;
@property (nonatomic, strong) NSString *mDescription;
@property (nonatomic, strong) NSString *mLocation;
@property (nonatomic, strong) NSString *mLevel;
@property (nonatomic, strong) NSString *mStatus;

+ (NSArray *) ALARM_LEVELS;
+ (NSArray *) sortAlarms:(NSArray *)alarms;
- (NSComparisonResult) compare:(Alarm *)other;
- (Alarm *) initWithRandomForParent:(NSString *) parentId;
- (Alarm *) initWithCode:(NSString *)code
                      Id:(NSString *)ID
                   Level:(NSString *)level
                    desc:(NSString *)desc
                location:(NSString *)location
                  parent:(NSString *)parent
                  status:(NSString *)status;
- (BOOL) pushResolved;

@end
