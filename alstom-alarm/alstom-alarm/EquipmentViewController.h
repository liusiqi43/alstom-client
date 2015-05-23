//
//  SecondViewController.h
//  alstom-alarm
//
//  Created by Siqi Liu on 5/20/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "NYOBetterZoomUIScrollView.h"

@interface EquipmentViewController : UIViewController

@property (weak, nonatomic) IBOutlet NYOBetterZoomUIScrollView *scrollView;

-(UIView *)addEquipmentToMapAtX:(float)x
                          Y:(float)y
                     radius:(float)r
               forEquipment:(Equipment *)equipment;

@end

