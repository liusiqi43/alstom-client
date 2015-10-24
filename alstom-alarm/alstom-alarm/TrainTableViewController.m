//
//  TrainTableViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "TrainTableViewController.h"
#import "EntityContainerViewController.h"
#import "Train.h"
#import "DataFetcher.h"
#import "Equipment.h"

@interface TrainTableViewController ()

@property (nonatomic, strong) NSMutableArray* mTrains;
@property (nonatomic, strong) NSMutableArray* mStations;

@end

@implementation TrainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.mStations == nil) {
        self.mTrains = [[DataFetcher sharedInstance] fetchTrains];
        [self.mTrains sortUsingSelector:@selector(compareAlarmLevelWithOther:)];
        [self.tableView reloadData];
    }
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
    if (self.mStations != nil) {
        return [self.mStations count] + 1;
    }
    return [self.mTrains count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
            UILabel *col1 = (UILabel *) [cell viewWithTag:1];
            UILabel *col2 = (UILabel *) [cell viewWithTag:2];
            UILabel *col3 = (UILabel *) [cell viewWithTag:3];
            UILabel *col4 = (UILabel *) [cell viewWithTag:4];
            if (self.mStations != nil) {
                [col1 setText:@"Station Name"];
                [col2 setText:@""];
                [col3 setText:@""];
                [col4 setText:@"Alarms"];
            } else {
                [col1 setText:@"Train ID"];
                [col2 setText:@"Station"];
                [col3 setText:@"Direction"];
                [col4 setText:@"Alarms"];
            }
            break;
        }
        default: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"train_row" forIndexPath:indexPath];
            UILabel *field_id = (UILabel *) [cell viewWithTag:1];
            UILabel *field_station = (UILabel *) [cell viewWithTag:2];
            UILabel *field_direction = (UILabel *) [cell viewWithTag:3];
            UILabel *field_alarms = (UILabel *) [cell viewWithTag:4];
            if (self.mStations != nil) {
                Equipment *equipment = [self.mStations objectAtIndex:indexPath.row-1];
                [field_id setText:equipment.mId];
                [field_station setText:@""];
                [field_direction setText:@""];
                [field_alarms setText:[NSString stringWithFormat:@"%lu", (unsigned long)[equipment.mAlarms count]]];
                
                NSString *max_level = [equipment getMaxLevel];
                if (max_level != nil) {
                    if ([max_level  isEqual: @"ERROR"]) {
                        [cell setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2f]];
                    } else if ([max_level  isEqual: @"WARNING"]) {
                        [cell setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2f]];
                    } else if ([max_level  isEqual: @"INFO"]) {
                        [cell setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
                    }
                } else {
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
            } else {
                Train *train = [self.mTrains objectAtIndex:indexPath.row-1];
                [field_id setText:train.mId];
                [field_station setText:train.mStation];
                [field_direction setText:train.mDirection];
                [field_alarms setText:[NSString stringWithFormat:@"%lu", (unsigned long)[train.mAlarms count]]];
                
                NSString *max_level = [train getMaxLevel];
                if (max_level != nil) {
                    if ([max_level  isEqual: @"ERROR"]) {
                        [cell setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2f]];
                    } else if ([max_level  isEqual: @"WARNING"]) {
                        [cell setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2f]];
                    } else if ([max_level  isEqual: @"INFO"]) {
                        [cell setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
                    }
                } else if ([train.mStatus isEqual: @"ON_RAILS"]) {
                    [cell setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.2f]];
                }
                if ([train.mStatus isEqual: @"OUT_OF_SERVICE"]) {
                    [cell setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f]];
                }
            }
            break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mStations != nil) {
        Equipment *equipment = [self.mStations objectAtIndex:indexPath.row-1];
        [self performSegueWithIdentifier:@"show_details" sender:equipment];
    } else {
        Train *train = [self.mTrains objectAtIndex:indexPath.row-1];
        [self performSegueWithIdentifier:@"show_details" sender:train];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"show_details"]) {
        EntityContainerViewController * vc = (EntityContainerViewController *)[segue destinationViewController];
        if (self.mStations != nil) {
            Equipment *e = (Equipment *) sender;
            [vc setMEntity:e];
        } else {
            Train *train = (Train *) sender;
            [vc setMEntity:train];
        }
    }
}


@end
