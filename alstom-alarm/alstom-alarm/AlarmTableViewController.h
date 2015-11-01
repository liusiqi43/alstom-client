//
//  AlarmTableViewController.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//
#ifndef ALARM_TABLE_VIEW_CONTROLLER_H_
#define ALARM_TABLE_VIEW_CONTROLLER_H_

#import <UIKit/UIKit.h>

@class EntityContainerViewController;

@interface AlarmTableViewController : UITableViewController

@property (weak, nonatomic) EntityContainerViewController *mParentVC;

@end

#endif