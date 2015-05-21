//
//  Alarm.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "Alarm.h"
#import "DataFetcher.h"

@implementation Alarm

+ (NSArray *) ALARM_LEVELS
{
    static NSArray* ALARM_LEVELS = nil;
    
    if (ALARM_LEVELS == nil)
    {
        // Increasing order
        ALARM_LEVELS = [[NSArray alloc] initWithObjects:@"Info", @"Warn", @"Err", nil];
    }
    
    return ALARM_LEVELS;
}

- (Alarm *) initWithRandomForParent:(NSString *) parentId
{
    self.mParentId = parentId;
    NSArray * alarmCodes = [NSArray arrayWithObjects:@"200", @"500", @"204", @"304", @"105", nil];
    self.mAlarmCode = [alarmCodes objectAtIndex:arc4random() % [alarmCodes count]];
    NSArray * ids = [NSArray arrayWithObjects:@"T1231", @"T1234", @"T2024", @"E3204", @"E0105", nil];
    self.mId = [ids objectAtIndex:arc4random() % [ids count]];
    NSArray * levels = [NSArray arrayWithObjects:@"Err", @"Warn", @"Info", nil];
    self.mLevel = [levels objectAtIndex:arc4random() % [levels count]];
    self.mDescription = @"No big deal";
    return self;
}

- (void) pushResolved
{
    [[DataFetcher sharedInstance] setAlarmResolved:self.mId];
}

- (NSComparisonResult) compare:(Alarm *)other
{
    int self_index = (int)[[Alarm ALARM_LEVELS] indexOfObject:self.mLevel];
    int other_index = (int)[[Alarm ALARM_LEVELS] indexOfObject:other.mLevel];
    
    if (self_index > other_index) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

@end
