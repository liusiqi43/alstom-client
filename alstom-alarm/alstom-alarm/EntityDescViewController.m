//
//  EntityDescViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/21/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "EntityDescViewController.h"
#import "EntityContainerViewController.h"
#import "Entity.h"

@interface EntityDescViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mDesc1;
@property (weak, nonatomic) IBOutlet UILabel *mDesc2;
@property (weak, nonatomic) IBOutlet UILabel *mDesc3;
@property (weak, nonatomic) id<Entity> mEntity;

@end

@implementation EntityDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mEntity = [(EntityContainerViewController *)[self parentViewController] mEntity];
    [self.mTitle setText:[self.mEntity getTitle]];
    [self.mDesc1 setText:[self.mEntity getDesc1]];
    [self.mDesc2 setText:[self.mEntity getDesc2]];
    [self.mDesc3 setText:[self.mEntity getDesc3]];
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
