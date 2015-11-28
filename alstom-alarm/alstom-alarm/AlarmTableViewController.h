#ifndef ALARM_TABLE_VIEW_CONTROLLER_H_
#define ALARM_TABLE_VIEW_CONTROLLER_H_

#import <UIKit/UIKit.h>

@class EntityContainerViewController;

@interface AlarmTableViewController : UITableViewController

@property (weak, nonatomic) EntityContainerViewController *mParentVC;

@end

#endif