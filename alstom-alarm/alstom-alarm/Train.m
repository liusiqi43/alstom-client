//
//  Train.m
//  ios
//
//  Created by Siqi Liu on 12/23/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Train.h"
#import "Alarm.h"

@implementation Train

- (Train *) initWithDirection:(NSString *)direction
                      Station:(NSString *)station
                           Id:(NSString *)tid
                       Status:(NSString *)status
                       alarms:(NSMutableArray *)alarms
{
    self = [self init];
    self.mDirection = direction;
    self.mStation = station;
    self.mId = tid;
    self.mStatus = status;
    self.mAlarms = alarms;
    return self;
}

- (NSComparisonResult) compareAlarmLevelWithOther: (Train *) other
{
    if ([self.mStatus isEqualToString:@"OUT_OF_SERVICE"] && [other.mStatus isEqualToString:@"ON_RAILS"]) {
        return NSOrderedDescending;
    } else if ([self.mStatus isEqualToString:@"ON_RAILS"] && [other.mStatus isEqualToString:@"OUT_OF_SERVICE"]) {
        return NSOrderedAscending;
    }
    
    int self_max_level = -1;
    int other_max_level = -1;
    
    for (Alarm *alarm in self.mAlarms) {
        int index = (int)[[Alarm ALARM_LEVELS] indexOfObject:alarm.mLevel];
        self_max_level = MAX(index, self_max_level);
    }
    
    for (Alarm *alarm in other.mAlarms) {
        int index = (int)[[Alarm ALARM_LEVELS] indexOfObject:alarm.mLevel];
        other_max_level = MAX(index, other_max_level);
    }
    
    if (self_max_level > other_max_level) {
        return NSOrderedAscending;
    } else if (self_max_level < other_max_level) {
        return NSOrderedDescending;
    }
               
    // equal
    if ([self.mAlarms count] > [other.mAlarms count]) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

- (NSString *) getMaxLevel
{
    int self_max_level = -1;
    
    for (Alarm *alarm in self.mAlarms) {
        int index = (int)[[Alarm ALARM_LEVELS] indexOfObject:alarm.mLevel];
        self_max_level = MAX(index, self_max_level);
    }
    
    return self_max_level > -1 ? [[Alarm ALARM_LEVELS] objectAtIndex:self_max_level] : nil;
}

- (NSString *)getTitle
{
    return [NSString stringWithFormat:@"Train : %@", self.mId];
}

- (NSString *)getDesc1
{
    return [NSString stringWithFormat:@"Station : %@", self.mStation];
}

- (NSString *)getDesc2
{
    return [NSString stringWithFormat:@"Direction : %@", self.mDirection];
}

- (NSString *)getDesc3
{
    return @"";
}

- (NSArray *)getAlarms
{
    return [self.mAlarms sortedArrayUsingSelector:@selector(compare:)];
}

- (NSString *)getType
{
    return @"Train";
}

- (NSString *)getVisualUrl
{
    return @"/media/train.png";
}

@end
