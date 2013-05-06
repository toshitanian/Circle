//
//  CMArtistViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

//ref:https://developer.apple.com/jp/devcenter/ios/library/documentation/iPodLibraryAccess_Guide.pdf
//ref:http://iphone-dev.g.hatena.ne.jp/sawat/20090718/1247936645
//ref:http://iphone-dev.g.hatena.ne.jp/sawat/20090713/1247500025
@interface CMArtistViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_cv;
    NSMutableArray *_albums;
    MPMediaQuery *_query;
}

-(IBAction)pop:(id)sender;
@property (nonatomic, assign) NSInteger cellCount;

@end
