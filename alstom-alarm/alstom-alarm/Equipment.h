//
//  Equipement.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/22/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Equipment : NSObject <Entity>

@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSMutableArray *mAlarms;
@property (nonatomic, strong) NSString *mType;
// X, Y between 0, 1 and 0.0 0.0 is the top left corner.
@property float mX;
@property float mY;
// in percentage of the width of the map.
@property float mRadius;

- (Equipment *) initWithRandom;
- (Equipment *) initWithType:(NSString *)type
                          Id:(NSString *)ID
                           X:(float)x
                           Y:(float)y
                      radius:(float)radius
                      alarms:(NSMutableArray *)alarms;

- (NSString *) getMaxLevel;

@end
