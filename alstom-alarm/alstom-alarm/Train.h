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
@property (nonatomic, strong) NSMutableArray  *mAlarms;

- (Train *) initWithRandom;
- (NSComparisonResult) compareAlarmLevelWithOther: (Train *) other;
- (NSString *) getMaxLevel;
@end
