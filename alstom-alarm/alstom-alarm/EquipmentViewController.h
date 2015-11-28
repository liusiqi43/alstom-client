#import <UIKit/UIKit.h>
#import "Equipment.h"
#import "NYOBetterZoomUIScrollView.h"

@interface EquipmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *test;

@property (weak, nonatomic) IBOutlet NYOBetterZoomUIScrollView *scrollView;

-(UIView *)addEquipmentToMapAsShape:(CGRect)shape
                       forEquipment:(Equipment *)equipment;

@end

