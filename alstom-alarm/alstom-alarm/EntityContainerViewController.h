//
//  EntityContainerViewController.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"

@interface EntityContainerViewController : UIViewController

@property (weak, nonatomic) id <Entity> mEntity;

@end
