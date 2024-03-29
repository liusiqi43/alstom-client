//
//  AlarmTableViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "AlarmTableViewController.h"
#import "AttributedUIButton.h"
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
    return [self.mAlarms count];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        Alarm *alarm = [self.mAlarms objectAtIndex:[alertView tag]];
        if ([alarm pushResolved]) {
            [self.mParentVC resolveAlarm:alarm.mId];
            self.mAlarms = [[self.mAlarms sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
            [self.tableView reloadData];
            [self.view makeToast:@"Resolution registered."];
        }
    }
}

- (void) pushResolved:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:@"Do you confirm to resolve this alarm?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"Cancel", nil];
    NSNumber *number = [((AttributedUIButton *) sender).attrs objectForKey:@"cellindex"];
    [alert setTag:[number integerValue]];
    [alert show];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"alarm_row" forIndexPath:indexPath];
    
    Alarm *alarm = [self.mAlarms objectAtIndex:indexPath.row];
    UILabel *field = (UILabel *) [cell viewWithTag:1];
    AttributedUIButton *resolveButton = (AttributedUIButton *) [cell viewWithTag:5];
    
    
    [field setText:[[NSArray arrayWithObjects:alarm.mLevel, @": ", alarm.mDescription, @" @", alarm.mEquipmentId, nil] componentsJoinedByString:@""]];
    
    [resolveButton.attrs setValue:[NSNumber numberWithUnsignedLong:indexPath.row] forKey:@"cellindex"];
    [resolveButton addTarget:self action:@selector(pushResolved:) forControlEvents:UIControlEventTouchUpInside];
    resolveButton.hidden = NO;
    [cell setBackgroundColor:[[alarm AlarmColor] colorWithAlphaComponent:0.2f]];
    
    if ([alarm.mStatus isEqualToString:@"RESOLVED"]) {
        [cell setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f]];
        resolveButton.hidden = YES;
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
