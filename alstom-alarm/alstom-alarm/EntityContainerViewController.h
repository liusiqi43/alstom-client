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
