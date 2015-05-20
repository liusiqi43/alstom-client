//
//  UICollectionedTableViewCell.h
//  ios
//
//  Created by Siqi Liu on 12/24/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"

@interface UICollectionedTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) Train *train;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
