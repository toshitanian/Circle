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

#import "CMPlayerButtonView.h"


@interface CMViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CMAlbumViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UICollectionView *_cv;
    CMAlbumViewController *_artistViewController;
    CMAlbumViewController *_albumViewController;
    CMAlbumViewController *_songViewController;
    CMAlbumViewController *_playlistViewController;
    CMInfoViewController *_infoViewController;
    
    CGPoint _center;
    float _radius;
    float _interval_angle;
    
    BOOL _on[5];
    NSMutableArray *_views;
    
    CGPoint _point_tap_began;
    float _angle;
    
    float _scroll_speed;
    NSTimer *_tm;
}

@property (nonatomic, assign) NSInteger cellCount;
@end
