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
    
    UIImage *image = [[DataFetcher sharedInstance] getMainMap];
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
    return [self addEquipmentToMapAsShape:[equipment.mShape CGRectValue] forEquipment:equipment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.mEquipements = [NSMutableDictionary dictionary];
    self.mBubbles = [NSMutableArray array];
    
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
            if ([[equipment getMaxLevel] isEqualToString:@"ERROR"]) {
                [circleView startBlinkingWithColor:[[UIColor redColor] colorWithAlphaComponent:0.4f]
                                           default:[UIColor clearColor]];
            } else if ([[equipment getMaxLevel] isEqualToString:@"WARNING"]) {
                [circleView startBlinkingWithColor:[[UIColor yellowColor] colorWithAlphaComponent:0.4f]
                                           default:[UIColor clearColor]];
            }
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && sender.view.stringTag != nil)
    {
        Equipment* e = [self.mEquipements objectForKey:sender.view.stringTag];
        [self performSegueWithIdentifier:@"equipmentView" sender:e];
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

-(UIView *)addEquipmentToMapAsShape:(CGRect)shape
                       forEquipment:(Equipment *)equipment
{
    UIView *equipmentView = [[UIView alloc] initWithFrame:shape];
    
    [equipmentView setStringTag:equipment.mId];
    [self.scrollView.childView addSubview:equipmentView];
    [self.mBubbles addObject:equipmentView];
    return equipmentView;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"equipmentView"]) {
        Equipment *equipment = (Equipment *) sender;
        NSLog(@"Equipement: %@", equipment.mId);
        EntityContainerViewController * vc = (EntityContainerViewController *)[segue destinationViewController];
        [vc setMEntity:equipment];
    }
}


@end
