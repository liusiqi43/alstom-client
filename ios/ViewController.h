//
//  ViewController.h
//  ios
//
//  Created by Siqi Liu on 12/18/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

