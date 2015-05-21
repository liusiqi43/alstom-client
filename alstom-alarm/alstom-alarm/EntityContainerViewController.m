//
//  EntityContainerViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "EntityContainerViewController.h"
#import "EntityDescViewController.h"
#import "AlarmTableViewController.h"

@interface EntityContainerViewController ()

@end

@implementation EntityContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"entity_desc"]) {
        [(EntityDescViewController *)[segue destinationViewController] setMParentVC:self];
    } else if ([[segue identifier] isEqualToString:@"alarm_table"]) {
        [(AlarmTableViewController *)[segue destinationViewController] setMParentVC:self];
    }
}


@end
