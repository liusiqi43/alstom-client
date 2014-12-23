//
//  TrainsViewController.h
//  ios
//
//  Created by Siqi Liu on 12/23/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#ifndef ios_TrainsViewController_h
#define ios_TrainsViewController_h

#import <UIKit/UIKit.h>

@interface TrainsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *departureStationName;
@property (strong, nonatomic) NSString *arrivalStationName;

@end

#endif
