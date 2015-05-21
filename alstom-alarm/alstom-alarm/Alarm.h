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
@property (nonatomic, strong) NSString *mLevel;

+ (NSArray *) ALARM_LEVELS;
- (Alarm *) initWithRandomForParent:(NSString *) parentId;
- (void) pushResolved;

@end
