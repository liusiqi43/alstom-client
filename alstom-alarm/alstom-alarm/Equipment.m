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

- (Equipment *) initWithType:(NSString *)type
                        Name:(NSString *)name
                          Id:(NSString *)ID
                       Shape:(NSValue *)shape
                      Visual:(NSString *)visual
                      Alarms:(NSMutableArray *)alarms;
{
    self = [self init];
    self.mType = type;
    self.mId = ID;
    self.mName = name;
    self.mShape = shape;
    self.mAlarms = alarms;
    self.mVisual = visual;
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
    return [NSString stringWithFormat:@"%@", self.mName];
}

- (NSString *)getDesc3
{
    return [NSString stringWithFormat:@"%@", self.mName];
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


- (NSString *)getVisualUrl
{
    return _mVisual;
}

@end
