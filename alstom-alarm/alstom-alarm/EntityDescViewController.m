#import "EntityDescViewController.h"
#import "EntityContainerViewController.h"
#import "UIView+StringIdentifiedUIView.h"
#import "Entity.h"
#import "DataFetcher.h"
#import "Alarm.h"

@interface EntityDescViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mDesc1;
@property (weak, nonatomic) IBOutlet UILabel *mDesc2;

@end

@implementation EntityDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mTitle setText:[self.mParentVC.mEntity getTitle]];
    [self.mDesc1 setText:[self.mParentVC.mEntity getDesc1]];
    [self.mDesc2 setText:[self.mParentVC.mEntity getDesc2]];
    
    NSString *visualUrl = [self.mParentVC.mEntity getVisualUrl];
    UIImage *image = [[DataFetcher sharedInstance] getMediaWithUrl:visualUrl];
    UIImageView *subview = [[UIImageView alloc] initWithFrame:self.backgroundImage.frame];
    [subview setContentMode:UIViewContentModeScaleToFill];
    [subview setImage:image];
    [subview setBackgroundColor:[UIColor whiteColor]];
    subview.frame = CGRectMake(subview.frame.origin.x+(self.view.frame.size.width/2.0f - subview.frame.size.width/2.0f),
                               subview.frame.origin.y,
                               subview.frame.size.width,
                               subview.frame.size.height);
    [self.backgroundImage addSubview:subview];
    float hRatio = self.backgroundImage.frame.size.width / image.size.width;
    float vRatio = self.backgroundImage.frame.size.height / image.size.height;
    
    NSLog(@"%f, %f, %f", hRatio, vRatio, (self.view.frame.size.width/2.0f - subview.frame.size.width/2.0f));
    for (Alarm * a in [self.mParentVC.mEntity getAlarms]) {
        if (a.mShape != nil) {
            CGRect shape = CGRectMake(a.mShape.CGRectValue.origin.x * hRatio + (self.view.frame.size.width/2.0f - subview.frame.size.width/2.0f),
                                      a.mShape.CGRectValue.origin.y * vRatio,
                                      a.mShape.CGRectValue.size.width * hRatio,
                                      a.mShape.CGRectValue.size.height * vRatio);
            UIView * view = [[UIView alloc] initWithFrame:shape];
            [self.backgroundImage addSubview:view];
            NSLog(@"BG: origin = %@, size = %@", NSStringFromCGPoint(self.backgroundImage.frame.origin), NSStringFromCGSize(self.backgroundImage.frame.size));
            NSLog(@"Size = %@", NSStringFromCGSize(image.size));
            NSLog(@"before = %@; after = %@", NSStringFromCGRect(a.mShape.CGRectValue), NSStringFromCGRect(shape));
            NSLog(@"Storing %@", a.mId);
            [view setStringTag:a.mId];
            [view startBlinkingWithColor:[[a AlarmColor] colorWithAlphaComponent:0.2f]
                                 default:[UIColor clearColor]];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resolveAlarm:(NSString *)id
{
    for (UIView * v in [self.backgroundImage subviews]) {
        if ([v stringTag] == id) {
            [v removeFromSuperview];
        }
    }
    
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
