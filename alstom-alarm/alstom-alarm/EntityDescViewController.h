#ifndef ENTITY_DESC_VIEW_CONTROLLER_H_
#define ENTITY_DESC_VIEW_CONTROLLER_H_

#import <UIKit/UIKit.h>

@class EntityContainerViewController;

@interface EntityDescViewController : UIViewController

@property (weak, nonatomic) EntityContainerViewController *mParentVC;

- (void)resolveAlarm:(NSString *)id;

@end

#endif
