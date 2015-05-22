//
//  SecondViewController.m
//  alstom-alarm
//
//  Created by Siqi Liu on 5/20/15.
//  Copyright (c) 2015 j2s. All rights reserved.
//

#import "EquipmentViewController.h"
#import "Equipment.h"
#import "Entity.h"
#import "UIView+StringIdentifiedUIView.h"
#import "EntityContainerViewController.h"

@interface EquipmentViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableDictionary *mEquipements;
@property (strong, nonatomic) NSMutableArray *mBubbles;
@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mEquipements = [NSMutableDictionary dictionary];
    self.mBubbles = [NSMutableArray array];
    

    self.map.frame = self.scrollView.bounds;
    self.scrollView.contentSize = self.map.image.size;
    self.scrollView.delegate=self;
    NSLog(@"%f, %f", self.map.frame.size.width, self.map.image.size.width);
    
    for (int i=0; i<100; ++i) {
        Equipment *equipment = [[Equipment alloc] initWithRandom];
        if ([self.mEquipements objectForKey:equipment.mId] != nil)
            continue;
        [self.mEquipements setObject: equipment forKey:equipment.mId];
        UIView *circleView = [self addEquipmentToMapAtX:equipment.mX Y:equipment.mY radius:equipment.mRadius forEquipment:equipment];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onTap:)];
        [circleView addGestureRecognizer:singleFingerTap];
        
        NSString *level = [equipment getMaxLevel];
        if (level == nil) {
            [circleView stopBlinking];
        } else {
            if ([[equipment getMaxLevel] isEqualToString:@"Err"]) {
                [circleView startBlinkingWithColor:[UIColor redColor]];
            } else if ([[equipment getMaxLevel] isEqualToString:@"Warn"]) {
                [circleView startBlinkingWithColor:[UIColor yellowColor]];
            }
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && sender.view.stringTag != nil)
    {
        [self performSegueWithIdentifier:@"show_details" sender:[self.mEquipements objectForKey:sender.view.stringTag]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.map;
}

-(UIView *)addEquipmentToMapAtX:(float)x
                       Y:(float)y
                  radius:(float)r
               forEquipment:(Equipment *)equipment
{
    x *= self.map.image.size.width;
    y *= self.map.image.size.height;
    r *= self.map.image.size.width;
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(x-r, y-r, 2*r, 2*r)];
    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = r;
    circleView.backgroundColor = [UIColor whiteColor];
    
    [circleView setStringTag:equipment.mId];
    [self.map addSubview:circleView];
    [self.mBubbles addObject:circleView];
    return circleView;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"show_details"]) {
        Equipment *equipment = (Equipment *) sender;
        NSLog(@"Equipement: %@", equipment.mId);
        EntityContainerViewController * vc = (EntityContainerViewController *)[segue destinationViewController];
        [vc setMEntity:equipment];
    }
}


@end
