//
//  CMSongViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface CMSongViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_cv;
    NSMutableArray *_albums;
    IBOutlet UIView *_controller;
    UIButton *_btn_play;
    UIButton *_btn_next;
    UIButton *_btn_previous;
    
    IBOutlet UISlider *_slider;
    IBOutlet UILabel *_song_info;
    MPMediaQuery *_query;
}

-(IBAction)pop:(id)sender;
-(void)play_pushed;

@property (nonatomic, assign) NSInteger cellCount;
@property MPMusicPlayerController *player;
@property (atomic,assign) bool isPlaying;
@end
