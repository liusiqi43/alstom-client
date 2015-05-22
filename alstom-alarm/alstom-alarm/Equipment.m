//
//  Equipement.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/22/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "Equipment.h"
#import "Alarm.h"
#import "UIView+StringIdentifiedUIView.h"
#define ARC4RANDOM_MAX      0x100000000

@implementation Equipment

- (Equipment *) initWithRandom
{
    self = [self init];
    NSArray * types = [NSArray arrayWithObjects:@"Station", @"Aiguillage", nil];
    self.mType = [types objectAtIndex:arc4random() % [types count]];
    NSArray * tids = [NSArray arrayWithObjects:@"74HX12", @"73212", @"7@3HX12", @"44HX12", @"14HX12", @"74H212", @"14HX12", @"14HX12", nil];
    self.mId = [tids objectAtIndex:arc4random() % [tids count]];
    self.mX = ((double)arc4random() / ARC4RANDOM_MAX);
    self.mY = ((double)arc4random() / ARC4RANDOM_MAX);
    self.mRadius = 0.01;
    
    self.mAlarms = [[NSMutableArray alloc] init];
    NSInteger alarmCount = arc4random() % 3;
    for (int i=0; i<alarmCount; ++i) {
        [self.mAlarms addObject:[[Alarm alloc] initWithRandomForParent:self.mId]];
    }
    
    return self;
}

- (NSString *)getTitle
{
    return [NSString stringWithFormat:@"Equipment #%@", self.mId];
}

- (NSString *)getDesc1
{
    return [NSString stringWithFormat:@"%@", self.mType];
}

- (NSString *)getDesc2
{
    return [NSString stringWithFormat:@""];
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
    return self.mType;
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

@end
