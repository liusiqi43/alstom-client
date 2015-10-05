//
//  Entity.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Entity
@required
- (NSString *)getTitle;
- (NSString *)getDesc1;
- (NSString *)getDesc2;
- (NSString *)getDesc3;
- (NSString *)getVisualUrl;
- (NSArray *)getAlarms;
- (NSString *)getType;
@end