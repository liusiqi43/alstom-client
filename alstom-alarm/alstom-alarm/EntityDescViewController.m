//
//  EntityDescViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "EntityDescViewController.h"
#import "Entity.h"

@interface EntityDescViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mDesc1;
@property (weak, nonatomic) IBOutlet UILabel *mDesc2;
@property (weak, nonatomic) IBOutlet UILabel *mDesc3;

@end

@implementation EntityDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mTitle setText:[self.mParentVC.mEntity getTitle]];
    [self.mDesc1 setText:[self.mParentVC.mEntity getDesc1]];
    [self.mDesc2 setText:[self.mParentVC.mEntity getDesc2]];
    [self.mDesc3 setText:[self.mParentVC.mEntity getDesc3]];
    
    if ([[self.mParentVC.mEntity getType] isEqualToString:@"Train"]) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"train_bg"]];
    } else if ([[self.mParentVC.mEntity getType] isEqualToString:@"Station"]) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"station_bg"]];
    } else if ([[self.mParentVC.mEntity getType] isEqualToString:@"Aiguillage"]) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"aiguillage_bg"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
