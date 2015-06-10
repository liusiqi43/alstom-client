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
            [field_code setText:alarm.mAlarmCode];
            [field_level setText:alarm.mLevel];
            [field_desc setText:alarm.mDescription];
            [field_location setText:alarm.mParentId];
            
            if ([alarm.mLevel isEqual: @"CRITICAL"]) {
                [cell setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2f]];
            } else if ([alarm.mLevel isEqual: @"ERROR"]) {
                [cell setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2f]];
            } else if ([alarm.mLevel isEqual: @"WARNING"]) {
                [cell setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
            }
            break;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Alarm *alarm = [self.mAlarms objectAtIndex:indexPath.row-1];
        [alarm pushResolved];
        [self.mAlarms removeObject:alarm];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Resolved";
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
