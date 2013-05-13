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
#import "CMAlbumViewController.h"
#import "CMInfoViewController.h"


@interface CMViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CMAlbumViewControllerDelegate>
{
  UICollectionView *_cv;
    CMAlbumViewController *_artistViewController;
    CMAlbumViewController *_albumViewController;
    CMAlbumViewController *_songViewController;
    CMAlbumViewController *_playlistViewController;
    CMInfoViewController *_infoViewController;
}

@property (nonatomic, assign) NSInteger cellCount;
@end
