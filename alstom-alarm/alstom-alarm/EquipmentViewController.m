//
//  SecondViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/20/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "EquipmentViewController.h"

@interface EquipmentViewController () <UIScrollViewDelegate>

@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=CGSizeMake(1280, 960);
    self.scrollView.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.map;
}

@end
