//
//  TrainTableViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "TrainTableViewController.h"
#import "Train.h"

@interface TrainTableViewController ()

@property (nonatomic, strong) NSMutableArray* mTrains;

@end

@implementation TrainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTrains = [[NSMutableArray alloc] init];
    int nTrains = arc4random() % 10 + 20;
    for (int i=0; i<nTrains; ++i) {
        [self.mTrains addObject:[[Train alloc] initWithRandom]];
    }
    
    [self.mTrains sortUsingSelector:@selector(compareAlarmLevelWithOther:)];
    
    NSLog(@"Train counts: %lu", (unsigned long)[self.mTrains count]);
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
    NSLog(@"%lu", (unsigned long)[self.mTrains count]);
    return [self.mTrains count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"train_row" forIndexPath:indexPath];
            Train *train = [self.mTrains objectAtIndex:indexPath.row-1];
            UILabel *field_id = (UILabel *) [cell viewWithTag:1];
            UILabel *field_station = (UILabel *) [cell viewWithTag:2];
            UILabel *field_direction = (UILabel *) [cell viewWithTag:3];
            UILabel *field_alarms = (UILabel *) [cell viewWithTag:4];
            [field_id setText:train.mId];
            [field_station setText:train.mStation];
            [field_direction setText:train.mDirection];
            [field_alarms setText:[NSString stringWithFormat:@"%lu", (unsigned long)[train.mAlarms count]]];
            
            NSString *max_level = [train getMaxLevel];
            if (max_level != nil) {
                if ([max_level  isEqual: @"Err"]) {
                    [cell setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2f]];
                } else if ([max_level  isEqual: @"Warn"]) {
                    [cell setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2f]];
                } else if ([max_level  isEqual: @"Info"]) {
                    [cell setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
                }
            } else {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
