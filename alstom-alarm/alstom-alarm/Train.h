//
//  Train.h
//  ios
//
//  Created by Siqi Liu on 12/23/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Train : NSObject <Entity>

@property (nonatomic, strong) NSString *mStation;
@property (nonatomic, strong) NSString *mDirection;
@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *mStatus;
@property (nonatomic, strong) NSMutableArray  *mAlarms;
@property (nonatomic, strong) NSMutableDictionary  *mEquipments;

- (Train *) initWithDirection:(NSString *)direction
                      Station:(NSString *)station
                           Id:(NSString *)tid
                       Status:(NSString *)status
                       alarms:(NSMutableArray *)alarms;

- (NSComparisonResult) compareAlarmLevelWithOther: (Train *) other;
- (NSString *) getMaxLevel;
@end
