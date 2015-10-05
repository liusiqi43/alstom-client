//
//  EntityContainerViewController.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//
#ifndef ENTITY_CONTAINER_VIEW_CONTROLLER_H_
#define ENTITY_CONTAINER_VIEW_CONTROLLER_H_

#import <UIKit/UIKit.h>
#import "Entity.h"
#import "EntityDescViewController.h"
#import "AlarmTableViewController.h"

@interface EntityContainerViewController : UIViewController

@property (weak, nonatomic) id <Entity> mEntity;
@property (weak, nonatomic) EntityDescViewController * descVC;
@property (weak, nonatomic) AlarmTableViewController * alarmVC;

- (void) resolveAlarm:(NSString *)id;

@end

#endif
