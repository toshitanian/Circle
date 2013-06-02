//
//  CMPlayerViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#include <AVFoundation/AVFoundation.h>
#import "CMPlayerButtonView.h"

@interface CMMusicItem : NSObject

@property (nonatomic,retain) NSString *artist;
@property (nonatomic,retain) NSString *album;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) UIImage *artwork;
@property (atomic,assign) float fulltime;

@end


//http://secondflush2.blog.fc2.com/blog-entry-906.html#currentPlaybackTime
//http://secondflush2.blog.fc2.com/blog-entry-911.html MPMediaItem
//http://secondflush2.blog.fc2.com/blog-entry-907.html  MPMediaQuery
//http://netdiever.com/archives/11640
//http://secondflush2.blog.fc2.com/blog-entry-909.html Playlist

//http://ioohta.exblog.jp/tags/iPhone%E3%82%A2%E3%83%97%E3%83%AA/ play with AVPlayer
//https://developer.apple.com/jp/devcenter/ios/library/documentation/iPodLibraryAccess_Guide.pdf ドキュメント
//https://developer.apple.com/jp/devcenter/ios/library/documentation/EventHandlingiPhoneOS.pdf

//http://www.slideshare.net/funami/inside-of-attacca
//http://mtl.recruit.co.jp/blog/2012/07/iphone_dev_jpup.html
//http://www47.atwiki.jp/socup/m/pages/211.html?guid=on#id_e9391754

//UIimage http://iphone.moo.jp/app/?p=707

//http://akabeko.me/blog/2012/10/ios-video/ 全体の構成

//http://stackoverflow.com/questions/8106818/how-can-i-index-a-uitableview-with-the-users-ipod-library-artists インデックスの付け方．

@interface CMPlayerViewController : UIViewController<AVAudioSessionDelegate,UIGestureRecognizerDelegate>
{
    
    IBOutlet UIView *_controller;
    
    IBOutlet UILabel *_info_artist;
    IBOutlet UILabel *_info_title;
    IBOutlet UILabel *_info_album;
    IBOutlet UIImageView *_artwork;
    IBOutlet UIView *_shadow;
    IBOutlet UIView *_toast_next;
    IBOutlet UIView *_toast_previous;
    IBOutlet UISlider *_song_progress;
    
    IBOutlet UILabel *_current_time;
    IBOutlet UILabel *_full_time;
    IBOutlet UILabel *_queue_label;
    
    NSArray *collections;
    
    NSTimer *_tm;
    
    
    
    NSMutableArray *_items;
    NSMutableArray *_urls;
       NSMutableArray *_shuffled_urls;
    
    AVAudioSession *_audioSession;
    
    BOOL _isSkipping;
    IBOutlet CMPlayerButtonView *_twitter;
    IBOutlet CMPlayerButtonView *_pull;
    IBOutlet CMPlayerButtonView *_repeat;
    IBOutlet CMPlayerButtonView *_shuffle;
    
    BOOL _onArtwork;
    BOOL _onTwitter;
    BOOL _onPull;
    BOOL _onRepeat;
    BOOL _onShuffle;
    
    CGPoint _twitter_abs_point;
    CGPoint _pull_abs_point;
    CGPoint _repeat_abs_point;
    CGPoint _shuffle_abs_point;
    
    BOOL _should_resume;
    
    int _repeat_type;
    BOOL _isShuffling;
    
    NSArray *_shuffle_hash;
    //int _original_Index;
    BOOL _needShuffleReload;
    NSArray *_collections;
    
    int _item_count;

    UIImageView *_intro;
    int _intro_type;
    NSString  *current_title;
    NSString *current_album;
    NSString *current_artist;
    UIImage *current_artwork_img;
    UIImage *_no_artwork;
}

-(IBAction)dismiss:(id)sender;
-(void)play_pushed:(UIButton *)btn;
-(void)next_pushed:(UIButton *)btn;
-(void)previous_pushed:(UIButton *)btn;

@property MPMusicPlayerController *player;
@property (atomic,assign) BOOL isPlaying;
@property (atomic,assign) int currentIndex;

@property (atomic,assign) BOOL needReload;
@property (nonatomic,retain) MPMediaQuery *query;
@property (nonatomic,retain) AVQueuePlayer *player2;
@property (atomic,assign) BOOL isAvailable;

@property (atomic,assign)  int index_for_play;
@end
