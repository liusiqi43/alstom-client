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
#import "DataFetcher.h"
#import "UIView+StringIdentifiedUIView.h"
#import "EntityContainerViewController.h"

@interface EquipmentViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableDictionary *mEquipements;
@property (strong, nonatomic) NSMutableArray *mBubbles;

@end

@implementation EquipmentViewController

- (void)setMinimumZoomForCurrentFrame {
    UIImageView *imageView = (UIImageView *)[self.scrollView childView];
    
    // Work out a nice minimum zoom for the image - if it's smaller than the ScrollView then 1.0x zoom otherwise a scaled down zoom so it fits in the ScrollView entirely when zoomed out
    CGSize imageSize = imageView.image.size;
    CGSize scrollSize = self.scrollView.frame.size;
    CGFloat widthRatio = scrollSize.width / imageSize.width;
    CGFloat heightRatio = scrollSize.height / imageSize.height;
    CGFloat minimumZoom = MAX(1.0, (widthRatio > heightRatio) ? heightRatio : widthRatio);
    
    [self.scrollView setMinimumZoomScale:minimumZoom];
    NSLog(@"minimumZoom = %f, heightRatio = %f, widthRatio = %f", minimumZoom, heightRatio, widthRatio);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"zoomScale = %f", scrollView.zoomScale);
}


- (void)setMinimumZoomForCurrentFrameAndAnimateIfNecessary {
    BOOL wasAtMinimumZoom = NO;
    
    if(self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        wasAtMinimumZoom = YES;
    }
    
    [self setMinimumZoomForCurrentFrame];
    
    if(wasAtMinimumZoom || self.scrollView.zoomScale < self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }	
}

- (void)scrollViewSetup {
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setBouncesZoom:NO];
    [self.scrollView setDelegate:self];
    
    UIImage *image = [UIImage imageNamed:@"metro"];
    self.scrollView.childView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView.childView setUserInteractionEnabled:YES];
    // Finish the ScrollView setup
    [self.scrollView setContentSize:_scrollView.childView.frame.size];
    [self.scrollView setChildView:_scrollView.childView];
    [self.scrollView setMaximumZoomScale:6.0];
    [self setMinimumZoomForCurrentFrame];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Aspect ratio of ScrollView has changed, need to recalculate the minimum zoom
    [self setMinimumZoomForCurrentFrameAndAnimateIfNecessary];
}

- (UIView *)addEquipmentToMap:(Equipment *)equipment
{
    return [self addEquipmentToMapAtX:equipment.mX Y:equipment.mY radius:equipment.mRadius forEquipment:equipment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.mEquipements = [NSMutableDictionary dictionary];
    self.mBubbles = [NSMutableArray array];
    
    // Load map image from server
    [((UIImageView *) self.scrollView.childView) setImage:[[DataFetcher sharedInstance] fetchMap]];
    
    [self scrollViewSetup];
    
    NSArray *equipments = [[DataFetcher sharedInstance] fetchEquipments];
    for (Equipment *equipment in equipments) {
        if ([self.mEquipements objectForKey:equipment.mId] != nil)
            continue;
        [self.mEquipements setObject: equipment forKey:equipment.mId];
        UIView *circleView = [self addEquipmentToMap:equipment];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onTap:)];
        [circleView addGestureRecognizer:singleFingerTap];
        
        NSString *level = [equipment getMaxLevel];
        if (level == nil) {
            [circleView stopBlinking];
        } else {
            if ([[equipment getMaxLevel] isEqualToString:@"CRITICAL"]) {
                [circleView startBlinkingWithColor:[UIColor redColor]];
            } else if ([[equipment getMaxLevel] isEqualToString:@"ERROR"]) {
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
    return [self.scrollView childView];
}

-(UIView *)addEquipmentToMapAtX:(float)x
                       Y:(float)y
                  radius:(float)r
               forEquipment:(Equipment *)equipment
{
    x *= ((UIImageView *) self.scrollView.childView).image.size.width;
    y *= ((UIImageView *) self.scrollView.childView).image.size.height;
    r *= ((UIImageView *) self.scrollView.childView).image.size.width;
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(x-r, y-r, 2*r, 2*r)];
    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = r;
    circleView.backgroundColor = [UIColor blueColor];
    
    [circleView setStringTag:equipment.mId];
    [self.scrollView.childView addSubview:circleView];
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
