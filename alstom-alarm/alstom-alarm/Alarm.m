//
//  Alarm.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "Alarm.h"
#import "DataFetcher.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation Alarm

+ (NSArray *) ALARM_LEVELS
{
    static NSArray* ALARM_LEVELS = nil;
    
    if (ALARM_LEVELS == nil)
    {
        // Increasing order
        ALARM_LEVELS = [[NSArray alloc] initWithObjects:@"INFO", @"WARNING", @"ERROR", nil];
    }
    
    return ALARM_LEVELS;
}

- (Alarm *) initWithCode:(NSString *)code
                      Id:(NSString *)ID
                   Level:(NSString *)level
                    desc:(NSString *)desc
                  status:(NSString *)status
                   shape:(NSValue *)shape
               equipment:(NSString *)mEquipmentId
{
    self.mShape = shape;
    self.mId = ID;
    self.mAlarmCode = code;
    self.mLevel = level;
    self.mDescription = desc;
    self.mEquipmentId = mEquipmentId;
    
    return self;
}

+ (NSArray *) sortAlarms:(NSArray *)alarms
{
    return [alarms sortedArrayUsingSelector:@selector(compare:)];
}

- (BOOL) pushResolved
{
    if ([[DataFetcher sharedInstance] setAlarmResolved:self.mId]) {
        self.mStatus = @"RESOLVED";
        return YES;
    }
    return NO;
}

- (NSComparisonResult) compare:(Alarm *)other
{
    if ([self.mStatus isEqualToString:@"RESOLVED"]) {
        return NSOrderedDescending;
    } else if ([other.mStatus isEqualToString:@"RESOLVED"]) {
        return NSOrderedAscending;
    }
    
    int self_index = (int)[[Alarm ALARM_LEVELS] indexOfObject:self.mLevel];
    int other_index = (int)[[Alarm ALARM_LEVELS] indexOfObject:other.mLevel];
    
    if (self_index > other_index) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

- (UIColor *) AlarmColor
{
    if ([self.mAlarmCode isEqualToString:@"2"]) {
        return [UIColor yellowColor];
    } else if ([self.mAlarmCode isEqualToString:@"3"]) {
        return [UIColor redColor];
    }
    return [UIColor clearColor];
}

@end
