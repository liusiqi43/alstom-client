#import <UIKit/UIKit.h>
#import "Train.h"

@interface UICollectionedTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) Train *train;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
