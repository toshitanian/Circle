//
//  CMViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMContentCell.h"
#import "CMCircleLayout.h"


@interface CMViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
  UICollectionView *_cv;
}

@property (nonatomic, assign) NSInteger cellCount;
@end
