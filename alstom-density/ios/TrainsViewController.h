#ifndef ios_TrainsViewController_h
#define ios_TrainsViewController_h

#import <UIKit/UIKit.h>

@interface TrainsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *departureStationName;
@property (strong, nonatomic) NSString *arrivalStationName;
@property (strong, nonatomic) NSNumber *departureStationId;
@property (strong, nonatomic) NSNumber *arrivalStationId;

@end

#endif
