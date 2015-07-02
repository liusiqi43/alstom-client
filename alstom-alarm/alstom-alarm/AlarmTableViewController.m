//
//  AlarmTableViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "AlarmTableViewController.h"
#import "EntityContainerViewController.h"
#import "Entity.h"
#import "Alarm.h"
#import "UIView+Toast.h"

@interface AlarmTableViewController ()
@property (strong, nonatomic) NSMutableArray *mAlarms;
@end

@implementation AlarmTableViewController

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.mAlarms = [[self.mParentVC.mEntity getAlarms] mutableCopy];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mAlarms count]+1;
}

- (void) pushResolved:(UIButton *)sender {
    Alarm *alarm = [self.mAlarms objectAtIndex:sender.tag];
    if ([alarm pushResolved]) {
        self.mAlarms = [[self.mAlarms sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        [self.tableView reloadData];
        [self.view makeToast:@"Aquittement enregistré."];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"alarm_row" forIndexPath:indexPath];
            
            Alarm *alarm = [self.mAlarms objectAtIndex:indexPath.row - 1];
            UILabel *field_code = (UILabel *) [cell viewWithTag:1];
            UILabel *field_level = (UILabel *) [cell viewWithTag:2];
            UILabel *field_desc = (UILabel *) [cell viewWithTag:3];
            UILabel *field_location = (UILabel *) [cell viewWithTag:4];
            UIButton *resolveButton = (UIButton *) [cell viewWithTag:5];
            [field_code setText:alarm.mAlarmCode];
            [field_level setText:alarm.mLevel];
            [field_desc setText:alarm.mDescription];
            [field_location setText:alarm.mParentId];
            
            [resolveButton setTag:indexPath.row-1];
            [resolveButton addTarget:self action:@selector(pushResolved:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([alarm.mLevel isEqualToString: @"CRITICAL"]) {
                [cell setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2f]];
            } else if ([alarm.mLevel isEqualToString: @"ERROR"]) {
                [cell setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2f]];
            } else if ([alarm.mLevel isEqualToString: @"WARNING"]) {
                [cell setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
            }
            
            if ([alarm.mStatus isEqualToString:@"RESOLVED"]) {
                [cell setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f]];
            }
            break;
    }
    
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
