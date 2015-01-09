//
//  TrainsViewController.m
//  ios
//
//  Created by Siqi Liu on 12/23/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainsViewController.h"
#import "UICollectionedTableViewCell.h"
#import "DataFetcher.h"
#import "Train.h"
#import "AMGProgressView.h"

@interface TrainsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// retain ownership, fetcher does not own, no caching.
@property (nonatomic, strong) NSArray *trains;
@end

@implementation TrainsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    // Fetching trains here.
    NSLog(@"D: %@, A: %@", _departureStationName, _arrivalStationName);
    _trains = [[DataFetcher sharedInstance] fetchTrainsForDeparture:_departureStationName
                                                            Arrival:_arrivalStationName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 3 : [_trains count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Information" : @"Prochains Trains";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripInfo" forIndexPath:indexPath];
        UILabel *detail = (UILabel *)[cell viewWithTag:2];
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        switch (indexPath.row) {
            case 0: {
                [detail setText:@"8"];
                [title setText:@"Ligne"];
                break;
            }
            case 1: {
                [detail setText:_departureStationName];
                [title setText:@"Départ"];
                break;
            }
            case 2: {
                [detail setText:_arrivalStationName];
                [title setText:@"Arrivée"];
                break;
            }
            default:
                break;
        }
        return cell;
    }
    UICollectionedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trainInfo" forIndexPath:indexPath];
    NSLog(@"setTrain");
    [cell setTrain:[self.trains objectAtIndex:indexPath.row]];
    NSLog(@"setTrain done");   
    NSString *attente = nil;
    if ([cell.train.arrivalTime intValue] < 1) {
        attente = @"À l'approche";
    } else {
        attente = [NSString stringWithFormat:@"Attente: %@ min", cell.train.arrivalTime];
    }

    [((UILabel *) [cell viewWithTag:6]) setText: attente];
    ((AMGProgressView *) [cell viewWithTag:5]).gradientColors = @[[UIColor blueColor], [UIColor redColor]];
    ((AMGProgressView *) [cell viewWithTag:5]).progress = [cell.train.avgDensity floatValue];
    [cell.collectionView reloadData];
    return cell;
}


@end